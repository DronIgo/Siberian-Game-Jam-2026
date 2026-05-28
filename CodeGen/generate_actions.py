import json
import os
import re
from pathlib import Path
from dataclasses import dataclass
from typing import Optional


# ===== НАСТРОЙКИ =====
PLAYER_ACTION_JSON_PATH = "../Files/ActionStats/player_action_stats.json"
HEALTHY_ACTION_JSON_PATH = "../Files/ActionStats/healthy_action_stats.json"
SICK_ACTION_JSON_PATH = "../Files/ActionStats/sick_action_stats.json"
SHOP_ACTION_JSON_PATH = "../Files/ActionStats/shop_item_action_stats.json"
EVIL_COMMON_ACTION_JSON_PATH = "../Files/ActionStats/evil_action_common_stats.json"
EVIL_SPECIAL_ACTION_JSON_PATH = "../Files/ActionStats/evil_action_special_stats.json"

STATUS_STATS_PATH = "../Files/Status/status_stats.json"

OUTPUT_DIR_PLAYER = "../Scripts/Logic/Fight/Actions/Gen/Player"
OUTPUT_DIR_SHOP = "../Scripts/Logic/Fight/Actions/Gen/Shop"
OUTPUT_DIR_ORGANS = "../Scripts/Logic/Fight/Actions/Gen/Organs"
OUTPUT_DIR_EVIL_ORGANS = "../Scripts/Logic/Fight/Actions/Gen/EvilOrgans"

BASE_CLASS = "ActionBase"

# Путь к ActionGenerator.gd относительно папки CodeGen
GENERATOR_PATH = "../Scripts/Logic/Fight/Actions/ActionGenerator.gd"

# Маркеры для секций в take_action()
EFFECTS_START_MARKER = "\t##EFFECTS START"
EFFECTS_END_MARKER = "\t##EFFECTS END"


# ===== ПАРСИНГ НОВОГО ФОРМАТА EFFECTS =====

EFFECT_PATTERN = re.compile(
    r"^(?P<target>target\d+|targets|initiator)"
    r"->"
    r"(?P<action>[\w-]+)"
    r"(?:\[(?P<arg>.+)\])?$"
)


@dataclass
class ParsedEffect:
    """Распарсенный эффект из строки формата {target}->{action}[{arg}]."""
    target: str         # "target0", "target1", ..., "targets", "initiator"
    action: str         # "damage", "heal", или имя статуса
    arg: Optional[str]  # аргумент (необязательный), например "damage", "amount", "protected(initiator)"


def parse_effect(effect_str: str) -> Optional[ParsedEffect]:
    """Парсит строку эффекта. Возвращает None если формат неверный."""
    m = EFFECT_PATTERN.match(effect_str.strip())
    if not m:
        print(f"Warning: cannot parse effect string: {effect_str}")
        return None
    return ParsedEffect(
        target=m.group("target"),
        action=m.group("action"),
        arg=m.group("arg"),
    )


def is_indexed_target(target: str) -> bool:
    """target0, target1, ... — индексный target (вне цикла по индексу)."""
    return bool(re.match(r"^target\d+$", target))


def extract_target_index(target: str) -> int:
    """Извлекает индекс из target0, target1 и т.д."""
    m = re.match(r"^target(\d+)$", target)
    return int(m.group(1)) if m else 0


# ===== ВСПОМОГАТЕЛЬНЫЕ =====

def extract_template_variables(text: str) -> set[str]:
    return set(re.findall(r"{([\w.]+)}", text))


def snake_to_pascal(name: str) -> str:
    parts = re.split(r'[-_]', name)
    return ''.join(part.capitalize() for part in parts)


def snake_to_upper(name: str) -> str:
    return name.replace('-', '_').upper()


def gdscript_value(value):
    if isinstance(value, str):
        return f'"{value}"'
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, list):
        items = ", ".join(gdscript_value(v) for v in value)
        return f"[{items}]"
    return str(value)


def get_gdscript_type(value):
    if isinstance(value, int):
        return "int"
    if isinstance(value, float):
        return "float"
    if isinstance(value, bool):
        return "bool"
    if isinstance(value, str):
        return "String"
    if isinstance(value, list):
        return "Array"
    return "Variant"


# ===== ЗАГРУЗКА status_stats =====

def load_status_names() -> set[str]:
    status_path = Path(__file__).resolve().parent / STATUS_STATS_PATH
    if not status_path.exists():
        print(f"Warning: status stats not found at {status_path}")
        return set()
    with open(status_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    return {name for name in data if not name.startswith("__")}


# ===== ГЕНЕРАЦИЯ КОДА ДЛЯ ЭФФЕКТОВ =====

def resolve_target_expr(pe: ParsedEffect) -> str:
    """
    Возвращает GDScript-выражение для целевого объекта:
      - target0, target1, ... → targets[0], targets[1], ...
      - initiator → initiator
      - targets → t (используется внутри for-цикла)
    """
    if pe.target == "initiator":
        return "initiator"
    elif pe.target == "targets":
        return "t"
    elif pe.target == "target":
        return "targets[0]"
    elif is_indexed_target(pe.target):
        idx = extract_target_index(pe.target)
        return f"targets[{idx}]"
    return "targets[0]"


def generate_effect_code(pe: ParsedEffect, status_names: set[str], inside_loop: bool) -> list[str]:
    """
    Генерирует GDScript код для одного распарсенного эффекта.

    inside_loop=True — код пишется с отступом \t\t (внутри for t in targets)
    inside_loop=False — код пишется с отступом \t (вне цикла)
    """
    target_expr = resolve_target_expr(pe)
    prefix = "\t\t" if inside_loop else "\t"
    lines = []

    if pe.action == "damage":
        dmg_src = pe.arg if pe.arg else "damage"
        lines.append(f"{prefix}var actual_damage = initiator.calc_damage_dealt({dmg_src})")
        lines.append(f"{prefix}var damage_dealt : int = {target_expr}.take_damage(actual_damage, _damage_type)")

    elif pe.action == "heal":
        heal_src = pe.arg if pe.arg else "amount"
        lines.append(f"{prefix}{target_expr}.heal({heal_src})")

    elif pe.action == "restore_mana":
        restore_src = pe.arg if pe.arg else "amount"
        lines.append(f"{prefix}{target_expr}.restore_mana({restore_src})")

    elif pe.action == "add_status":
        # Парсим аргумент статуса: может быть просто имя или имя(аргументы)
        status_arg = pe.arg
        status_name = status_arg
        init_args = ""
        
        # Проверяем, есть ли аргументы инициализации в формате status_name(args)
        init_match = re.match(r'^(\w+)\((.*)\)$', status_arg)
        if init_match:
            status_name = init_match.group(1)
            init_args = init_match.group(2)
        
        upper_name = snake_to_upper(status_name)
        if status_name in status_names:
            if init_args:
                # Вызываем init(...) с переданными аргументами
                lines.append(
                    f"{prefix}var status_{status_name} = SEG.create_status(StatusGenerator.STATUS.{upper_name})"
                )
                lines.append(
                    f"{prefix}status_{status_name}.init({init_args})"
                )
                lines.append(
                    f"{prefix}{target_expr}.apply_status(status_{status_name})"
                )
            else:
                lines.append(
                    f"{prefix}{target_expr}.apply_status(SEG.create_status(StatusGenerator.STATUS.{upper_name}))"
                )
        else:
            lines.append(f"{prefix}#TODO: apply status '{status_name}' to {target_expr}")
            if init_args:
                lines.append(
                    f"{prefix}var status_{status_name} = SEG.create_status(StatusGenerator.STATUS.{upper_name})"
                )
                lines.append(
                    f"{prefix}status_{status_name}.init({init_args})"
                )
                lines.append(
                    f"{prefix}{target_expr}.apply_status(status_{status_name})"
                )
            else:
                lines.append(
                    f"{prefix}{target_expr}.apply_status(SEG.create_status(StatusGenerator.STATUS.{upper_name}))"
                )

    elif pe.action == "remove_status_by_type":
        upper_name = snake_to_upper(pe.arg)
        if pe.arg in status_names:
            lines.append(
                f"{prefix}{target_expr}.remove_status_by_type(SEG.STATUS.{upper_name})"
            )
        
    elif pe.action == "remove_status_by_tag":
        lines.append(
            f"{prefix}{target_expr}.remove_status_by_tag(\"{pe.arg}\")"
        )
    
    elif pe.action == "remove_all_statuses_by_tag":
        lines.append(
            f"{prefix}{target_expr}.remove_all_statuses_by_tag(\"{pe.arg}\")"
        )

    return lines


# ===== ГЕНЕРАЦИЯ take_action() =====

def generate_result_format_output(config: dict, ) -> list[str]:
    lines = []
    result_format = config.get("result_format", "")

    if result_format:
        lines.append("\tvar format_dict : Dictionary = {}")
        used_vars = extract_template_variables(result_format)
        for var in used_vars:
            if var == "target.lore_name":
                lines.append(f'\tformat_dict["{var}"] = targets[0].lore_name')
            else:
                lines.append(f'\tformat_dict["{var}"] = {var}')
        lines.append("")
        lines.append(
            f'\treturn ActionResult.new(result_format, format_dict)'
        )
    else:
        lines.append("\treturn null")

    lines.append("")
    return lines

def generate_take_action_block(action_name: str, config: dict, status_names: set[str]) -> list[str]:
    """
    Генерирует take_action() на основе effects (новый формат) и result_format.

    Логика:
      - target0, target1, ... → применяется к targets[0], targets[1] ... ВНЕ цикла
      - initiator → применяется к initiator ВНЕ цикла
      - targets → применяется в for t in targets: ко всем целям
    """
    lines = []
    lines.append(
        "func take_action(initiator: ActorBase, targets : Array) -> ActionResult:"
    )
    lines.append("\tsuper.take_action(initiator, targets)")

    raw_effects = config.get("effects", [])

    # Парсим все эффекты
    parsed_effects: list[ParsedEffect] = []
    for raw in raw_effects:
        pe = parse_effect(raw)
        if pe:
            parsed_effects.append(pe)

    if not parsed_effects:
        lines.append("\tvar target: ActorBase = targets[0]")
        lines.append("")
        lines.append(EFFECTS_START_MARKER)
        lines.append(EFFECTS_END_MARKER)
        lines.append("")
        lines.extend(generate_result_format_output(config))
        return lines

    lines.append("")

    # Разделяем: в цикл (targets) и вне цикла (targetN, initiator)
    loop_effects = [pe for pe in parsed_effects if pe.target == "targets"]
    non_loop_effects = [pe for pe in parsed_effects if pe.target != "targets"]

    # Открывающий маркер
    lines.append(EFFECTS_START_MARKER)

    # Эффекты ВНЕ цикла: target0 -> targets[0], initiator -> initiator
    for pe in non_loop_effects:
        code = generate_effect_code(pe, status_names, inside_loop=False)
        lines.extend(code)

    # Эффекты В ЦИКЛЕ: targets -> t
    if loop_effects:
        lines.append("\tfor t: ActorBase in targets:")
        for pe in loop_effects:
            code = generate_effect_code(pe, status_names, inside_loop=True)
            lines.extend(code)

    # Закрывающий маркер
    lines.append(EFFECTS_END_MARKER)
    lines.append("")

    # Формируем result_format
    lines.extend(generate_result_format_output(config))
    return lines


# ===== ГЕНЕРАЦИЯ ФАЙЛА ДЕЙСТВИЯ =====

def generate_const_block(config: dict) -> list[str]:
    skip_fields = {"name", "description", "sound", "target_priority",
                   "effects", "result_format", "lore_name", "damage_type"}
    lines = ["# constants from config"]
    for key, value in config.items():
        if key in skip_fields:
            continue
        gd_type = get_gdscript_type(value)
        lines.append(
            f"const {key} : {gd_type} = {gdscript_value(value)}"
        )
    return lines


def generate_init_block(action_name: str, config: dict) -> list[str]:
    lines = []
    lines.append("func _init() -> void:")

    lore_name = config.get("name", action_name)
    description = config.get("description", "")
    sound = config.get("sound", "")
    result_format = config.get("result_format", "")

    lines.append(f'\tlore_name = "{lore_name}"')
    lines.append(f'\tdescription = "{description}"')
    lines.append(f'\tresult_format = "{result_format}"')

    if sound:
        lines.append(f'\tusage_sound_name = "{sound}"')

    if "damage_type" in config:
        lines.append(
            f'\t_damage_type = FightConst.DAMAGE_TYPE.{config["damage_type"]}'
        )

    if "tags" in config:
        tags_val = config["tags"]
        if isinstance(tags_val, str):
            lines.append(f'\t_tags = ["{tags_val}"]')
        else:
            lines.append(f'\t_tags = {gdscript_value(tags_val)}')

    manacost = config.get("manacost", 0)
    lines.append(f'\t_manacost = manacost')

    lines.append("")
    return lines


def generate_get_priority_block(config: dict) -> list[str]:
    """Генерирует get_priority() на основе target_priority.
    
    Поддерживает составные условия через || (например "self||friendly").
    """
    lines = []
    lines.append(
        "func get_priority(actor : ActorBase, own : OrganBase) -> int:"
    )

    target_priority = config.get("target_priority", [])

    if not target_priority:
        lines.append("\treturn -1")
        lines.append("")
        return lines

    p = 3

    for target in target_priority:
        target = target.lower()

        conditions = target.split("||")

        cond_parts = []
        for c in conditions:
            c = c.strip()
            if c == "self":
                cond_parts.append("own == actor")
            elif c == "friendly":
                cond_parts.append("(actor is OrganBase and own.is_healthy == actor.is_healthy)")
            elif c == "enemy":
                cond_parts.append("(actor is OrganBase and own.is_healthy != actor.is_healthy)")
            elif c == "player":
                cond_parts.append("actor is PlayerActor")

        if cond_parts:
            lines.append("")
            lines.append("\tif " + " or ".join(cond_parts) + ":")
            lines.append("\t\treturn " + str(p))

        p -= 1

    lines.append("")
    lines.append("\treturn -1")
    lines.append("")
    return lines


def generate_full_file(action_name: str, config: dict, status_names: set[str]) -> str:
    class_name = f"Action{snake_to_pascal(action_name)}"

    lines = []
    lines.append("# This file is autogenerated")
    lines.append("")
    lines.append(f"class_name {class_name}")
    lines.append(f"extends {BASE_CLASS}")
    lines.append("")

    lines.extend(generate_const_block(config))
    lines.append("")
    lines.extend(generate_init_block(action_name, config))
    lines.extend(generate_get_priority_block(config))
    lines.extend(generate_take_action_block(action_name, config, status_names))

    return "\n".join(lines)


def generate_file_prefix(action_name: str) -> str:
    class_name = f"Action{snake_to_pascal(action_name)}"
    lines = [
        "# This file is autogenerated",
        "",
        f"class_name {class_name}",
        f"extends {BASE_CLASS}",
    ]
    return "\n".join(lines)


def update_existing_file(file_path: Path, action_name: str, config: dict, status_names: set[str]) -> str:
    """
    Обновляет существующий файл действия:
    - Всегда перезаписывает: константы, _init(), get_priority()
    - В take_action() сохраняет пользовательский код между ##EFFECTS END и var format_dict
    """
    old_content = file_path.read_text(encoding="utf-8")

    # Извлекаем пользовательский код из take_action()
    preserved_code = ""
    effects_end_pos = old_content.find(EFFECTS_END_MARKER)
    if effects_end_pos != -1:
        format_dict_pos = old_content.find("\tvar format_dict : Dictionary = {}", effects_end_pos)
        if format_dict_pos != -1:
            after_marker = effects_end_pos + len(EFFECTS_END_MARKER)
            snippet = old_content[after_marker:format_dict_pos]
            preserved_code = snippet.rstrip("\n")
        else:
            return_null_pos = old_content.find("\treturn null", effects_end_pos)
            if return_null_pos != -1:
                after_marker = effects_end_pos + len(EFFECTS_END_MARKER)
                snippet = old_content[after_marker:return_null_pos]
                preserved_code = snippet.rstrip("\n")

    # Собираем новый файл
    lines = []
    lines.append(generate_file_prefix(action_name))
    lines.append("")

    lines.extend(generate_const_block(config))
    lines.append("")

    lines.extend(generate_init_block(action_name, config))
    lines.extend(generate_get_priority_block(config))

    ta_lines = generate_take_action_block(action_name, config, status_names)

    if preserved_code:
        insert_idx = None
        for i, line in enumerate(ta_lines):
            if line == EFFECTS_END_MARKER:
                insert_idx = i + 1
                break

        if insert_idx is not None:
            custom_lines = preserved_code.split("\n")
            while custom_lines and custom_lines[0].strip() == "":
                custom_lines.pop(0)
            if custom_lines:
                ta_lines[insert_idx:insert_idx] = custom_lines

    lines.extend(ta_lines)

    return "\n".join(lines)


# ===== МОДИФИКАЦИЯ ActionGenerator.gd =====

def update_generator_file(actions_data: list[tuple[str, dict]]):
    generator_path = Path(GENERATOR_PATH).resolve()
    if not generator_path.exists():
        print(f"Warning: Generator file not found at {generator_path}")
        return

    content = generator_path.read_text(encoding="utf-8")

    func_lines = (
        "func generate_action_by_name(action_name : String) -> ActionBase:\n"
    )
    func_lines += "\tmatch action_name:\n"

    for name, _ in actions_data:
        class_name = f"Action{snake_to_pascal(name)}"
        func_lines += f'\t\t"{name}":\n'
        func_lines += f"\t\t\treturn {class_name}.new()\n"

    func_lines += "\treturn null"

    content = re.sub(
        r"func generate_action_by_name\(action_name : String\) -> ActionBase:.*?(?=\nfunc |\n#|\Z)",
        func_lines.strip(),
        content,
        flags=re.DOTALL,
    )

    generator_path.write_text(content, encoding="utf-8")
    print(f"Updated: {generator_path}")


# ===== MAIN =====

def main():
    os.makedirs(OUTPUT_DIR_PLAYER, exist_ok=True)
    os.makedirs(OUTPUT_DIR_SHOP, exist_ok=True)
    os.makedirs(OUTPUT_DIR_ORGANS, exist_ok=True)
    os.makedirs(OUTPUT_DIR_EVIL_ORGANS, exist_ok=True)

    status_names = load_status_names()
    actions_data = []

    files = [PLAYER_ACTION_JSON_PATH, HEALTHY_ACTION_JSON_PATH,
             SICK_ACTION_JSON_PATH, SHOP_ACTION_JSON_PATH,
             EVIL_COMMON_ACTION_JSON_PATH, EVIL_SPECIAL_ACTION_JSON_PATH]

    folders = [OUTPUT_DIR_PLAYER, OUTPUT_DIR_ORGANS,
               OUTPUT_DIR_ORGANS, OUTPUT_DIR_SHOP,
               OUTPUT_DIR_EVIL_ORGANS, OUTPUT_DIR_EVIL_ORGANS]

    for file, folder in zip(files, folders):
        with open(file, "r", encoding="utf-8") as f:
            data = json.load(f)

        defaults = data.get("__default__", {})

        for action_name, config in data.items():
            if action_name.startswith("__"):
                continue

            merged_config = defaults.copy()
            merged_config.update(config)

            class_name = f"Action{snake_to_pascal(action_name)}"
            file_path = Path(folder) / f"{class_name}.gd"

            if file_path.exists():
                content = update_existing_file(file_path, action_name, merged_config, status_names)
                print(f"Updated: {file_path}")
            else:
                content = generate_full_file(action_name, merged_config, status_names)
                print(f"Generated: {file_path}")

            with open(file_path, "w", encoding="utf-8") as f:
                f.write(content)

            actions_data.append((action_name, merged_config))

    update_generator_file(actions_data)


if __name__ == "__main__":
    main()