import json
import os
import re
import random
from pathlib import Path


# ===== НАСТРОЙКИ =====
STATS_JSON_PATH = "../Files/Status/status_stats.json"
EFFECTS_JSON_PATH = "../Files/Status/status_effects.json"
OUTPUT_DIR = "../Scripts/Logic/Fight/StatusEffects/Gen"

BASE_CLASS = "StatusEffectBase"

# Путь к StatusEffectGenerator.gd относительно папки CodeGen
GENERATOR_PATH = "../Scripts/Logic/Fight/StatusEffects/StatusEffectGenerator.gd"


# ===== ВСПОМОГАТЕЛЬНЫЕ =====

def extract_template_variables(text: str) -> set[str]:
    return set(re.findall(r"{([\w.]+)}", text))

def snake_to_pascal(name: str) -> str:
    return ''.join(word.capitalize() for word in name.split('_'))

def pascal_to_snake(name: str) -> str:
    return re.sub(r'(?<!^)(?=[A-Z])', '_', name).lower()

def snake_to_upper(name: str) -> str:
    return name.upper()


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


def generate_color_from_name(name: str) -> str:
    """Генерирует предсказуемый цвет на основе имени эффекта."""
    random.seed(name)
    r = round(random.uniform(0.2, 1.0), 3)
    g = round(random.uniform(0.2, 1.0), 3)
    b = round(random.uniform(0.2, 1.0), 3)
    return f"Color({r}, {g}, {b}, 1.0)"


# ===== ГЕНЕРАЦИЯ ФАЙЛА ЭФФЕКТА =====

# Keys that are not constants but special directives
SKIP_CONST_KEYS = {"lore_name", "description", "init", "effects_deal_damage", "effects_take_damage"}

# Маркеры для секций в on_damage_dealt / on_damage_taken
DEAL_DAMAGE_START_MARKER = "\t##DEAL_DAMAGE START"
DEAL_DAMAGE_END_MARKER   = "\t##DEAL_DAMAGE END"
TAKE_DAMAGE_START_MARKER = "\t##TAKE_DAMAGE START"
TAKE_DAMAGE_END_MARKER   = "\t##TAKE_DAMAGE END"


def generate_const_block(config: dict) -> list[str]:
    """Генерирует строки с константами из конфига."""
    lines = ["# constants from config"]
    for key, value in config.items():
        if key in SKIP_CONST_KEYS:
            continue
        gd_type = get_gdscript_type(value)
        lines.append(
            f"const {key} : {gd_type} = {gdscript_value(value)}"
        )
    return lines


def translate_effect_expr(expr: str) -> str:
    """Переводит выражение эффекта (напр. 'heal(damage)') в вызов GDScript на actor."""
    return f"actor.{expr}"


def generate_damage_event_block(method_name: str, start_marker: str, end_marker: str, effects: list[str]) -> list[str]:
    """Генерирует on_damage_dealt или on_damage_taken с маркерами для сохранения пользовательского кода."""
    lines = []
    lines.append(f"func {method_name}(actor : ActorBase, damage : int) -> void:")
    lines.append(start_marker)
    for expr in effects:
        lines.append(f"\t{translate_effect_expr(expr)}")
    lines.append(end_marker)
    lines.append("")
    return lines


def extract_preserved_code(content: str, end_marker: str, next_func_pattern: str) -> str:
    """Извлекает пользовательский код между end_marker и следующей функцией/концом файла."""
    end_pos = content.find(end_marker)
    if end_pos == -1:
        return ""
    after_marker = end_pos + len(end_marker)
    # Ищем следующую func или конец файла
    next_match = re.search(next_func_pattern, content[after_marker:])
    if next_match:
        snippet = content[after_marker: after_marker + next_match.start()]
    else:
        snippet = content[after_marker:]
    return snippet.strip("\n")


def generate_init_block(effect_name: str, config: dict) -> list[str]:
    """Генерирует содержимое _init()."""
    lines = []
    lore_name = config.get("lore_name", effect_name)
    description = config.get("description", "")

    lines.append(
        f"func _init(duration_ : int = default_duration) -> void:"
    )
    lines.append(f'\tlore_name = "{lore_name}"')
    lines.append(
        f'\tlore_description_template = "{description}"'
    )
    lines.append(
        f"\ttype = StatusGenerator.STATUS.{snake_to_upper(effect_name)}"
    )

    if "damage_type" in config:
        lines.append("\t_damage_type = FightConst.DAMAGE_TYPE[damage_type]")
    if "tags" in config:
        lines.append("\t_tags = tags")
    lines.append("\tsuper(duration_)")
    lines.append("")
    return lines


def generate_extra_init_block(config: dict) -> list[str]:
    """Генерирует содержимое init()."""
    lines = []
    lines.append("func init(" + config.get("init") + ") -> void:")
    lines.append("\t#TODO")
    lines.append("\tpass")
    return lines


def get_description_block(effect_name: str, config: dict) -> list[str]:
    """Генерирует содержимое get_description()."""
    description = config.get("description", "")
    lines = []
    lines.append("func get_description() -> String:")
    lines.append("\tvar format_dict : Dictionary = {}")

    used_variables = extract_template_variables(description)

    for key in used_variables:
        lines.append(f'\tformat_dict["{key}"] = {key}')

    lines.append("")
    lines.append(
        "\treturn lore_description_template.format(format_dict)"
    )
    lines.append("")
    return lines


def generate_full_file(effect_name: str, config: dict) -> tuple[str, str]:
    """Генерирует полный файл с нуля (если его ещё нет)."""
    class_name = f"StatusEffect{snake_to_pascal(effect_name)}"

    lines = []
    lines.append("# This file is autogenerated")
    lines.append("")
    lines.append(f"class_name {class_name}")
    lines.append(f"extends {BASE_CLASS}")
    lines.append("")

    lines.extend(generate_const_block(config))
    lines.append("")
    lines.extend(generate_init_block(effect_name, config))
    lines.append("")
    if "init" in config:
        lines.extend(generate_extra_init_block(config))
        lines.append("")


    lines.extend(get_description_block(effect_name, config))

    # on_turn_end
    lines.append(
        "func on_turn_end(actor : ActorBase, data = null) -> void:"
    )

    if "damage" in config:
        lines.append(
            "\tactor.take_damage(damage, _damage_type)"
        )

    lines.append("\tduration -= 1")
    lines.append("")

    # on_turn_start
    lines.append(
        "func on_turn_start(actor : ActorBase, data = null) -> void:"
    )
    lines.append("\tpass")
    lines.append("")

    # on_damage_dealt
    if "effects_deal_damage" in config:
        lines.extend(generate_damage_event_block(
            "on_damage_dealt",
            DEAL_DAMAGE_START_MARKER, DEAL_DAMAGE_END_MARKER,
            config["effects_deal_damage"]
        ))

    # on_damage_taken
    if "effects_take_damage" in config:
        lines.extend(generate_damage_event_block(
            "on_damage_taken",
            TAKE_DAMAGE_START_MARKER, TAKE_DAMAGE_END_MARKER,
            config["effects_take_damage"]
        ))

    return "\n".join(lines), class_name


def _rebuild_damage_event_block(
    content: str,
    method_name: str,
    start_marker: str,
    end_marker: str,
    effects: list[str],
) -> str:
    """
    Заменяет или добавляет on_damage_dealt / on_damage_taken.
    Пользовательский код между end_marker и следующей func сохраняется.
    """
    new_block_lines = generate_damage_event_block(method_name, start_marker, end_marker, effects)

    existing = re.search(
        rf"func {re.escape(method_name)}\(.*?\) -> void:.*?(?=\nfunc |\nclass_name |\n#|\Z)",
        content,
        flags=re.DOTALL,
    )

    if existing:
        old_block = existing.group(0)
        # Извлекаем пользовательский код после end_marker внутри старого блока
        preserved = extract_preserved_code(old_block, end_marker, r"\nfunc |\nclass_name |\n#|\Z")
        new_block = "\n".join(new_block_lines).rstrip("\n")
        if preserved:
            # Вставляем сохранённый код перед последней пустой строкой блока
            new_block = new_block.rstrip("\n") + "\n" + preserved
        content = content[:existing.start()] + new_block + content[existing.end():]
    else:
        new_block = "\n".join(new_block_lines)
        content = content.rstrip() + "\n\n" + new_block

    return content


def update_existing_file(file_path: Path, effect_name: str, config: dict) -> str:
    """Обновляет существующий файл: заменяет константы, _init() и get_description(), остальное оставляет."""
    content = file_path.read_text(encoding="utf-8")

    # 1. Заменяем блок констант (от "# constants from config" до пустой строки перед func)
    new_const_block = "\n".join(generate_const_block(config))

    content = re.sub(
        r"# constants from config\n(?:const .+\n?)*",
        new_const_block + "\n",
        content
    )

    # 2. Заменяем _init()
    new_init_block = "\n".join(generate_init_block(effect_name, config))

    content = re.sub(
        r"func _init\(.*?\) -> void:.*?(?=\nfunc |\nclass_name |\n#|\Z)",
        new_init_block,
        content,
        flags=re.DOTALL
    )

    # 3. Заменяем get_description()
    new_get_description = "\n".join(get_description_block(effect_name, config))

    content = re.sub(
        r"func get_description\(\) -> String:.*?(?=\nfunc |\nclass_name |\n#|\Z)",
        new_get_description,
        content,
        flags=re.DOTALL
    )

    # 4. Заменяем или добавляем on_damage_dealt (с сохранением пользовательского кода)
    if "effects_deal_damage" in config:
        content = _rebuild_damage_event_block(
            content, "on_damage_dealt",
            DEAL_DAMAGE_START_MARKER, DEAL_DAMAGE_END_MARKER,
            config["effects_deal_damage"]
        )

    # 5. Заменяем или добавляем on_damage_taken (с сохранением пользовательского кода)
    if "effects_take_damage" in config:
        content = _rebuild_damage_event_block(
            content, "on_damage_taken",
            TAKE_DAMAGE_START_MARKER, TAKE_DAMAGE_END_MARKER,
            config["effects_take_damage"]
        )

    return content


def generate_effect(effect_name: str, config: dict):
    class_name = f"StatusEffect{snake_to_pascal(effect_name)}"
    file_path = Path(OUTPUT_DIR) / f"{class_name}.gd"

    if file_path.exists():
        # Инкрементальное обновление
        content = update_existing_file(file_path, effect_name, config)
        return content, class_name, False
    else:
        # Полная генерация с нуля
        content, class_name = generate_full_file(effect_name, config)
        return content, class_name, True


# ===== МОДИФИКАЦИЯ StatusEffectGenerator.gd =====

def update_generator_file(effects_data: list[tuple[str, dict]]):
    """
    Модифицирует StatusEffectGenerator.gd:
    - Обновляет enum STATUS со всеми эффектами
    - Обновляет color_by_type с цветами для каждого эффекта
    - Обновляет create_status() с рабочим match
    """
    generator_path = Path(GENERATOR_PATH).resolve()
    if not generator_path.exists():
        print(f"Warning: Generator file not found at {generator_path}")
        return

    content = generator_path.read_text(encoding="utf-8")

    # Собираем имена эффектов в верхнем регистре
    effect_names_upper = []
    for name, _ in effects_data:
        effect_names_upper.append(snake_to_upper(name))

    # 1. Обновляем enum STATUS
    enum_lines = "\tenum STATUS {\n"
    for i, name in enumerate(effect_names_upper):
        comma = "," if i < len(effect_names_upper) - 1 else ""
        enum_lines += f"\t\t{name}{comma}\n"
    enum_lines += "\t}\n"

    content = re.sub(
        r"enum STATUS \{(?:[^}]*)\}",
        enum_lines.strip(),
        content,
        flags=re.DOTALL
    )

    # 2. Извлекаем существующие цвета из файла, чтобы сохранить их
    existing_colors = {}
    color_match = re.search(
        r"const color_by_type : Dictionary = \{(.*?)\}",
        content,
        flags=re.DOTALL
    )
    if color_match:
        for line in color_match.group(1).split("\n"):
            line = line.strip()
            m = re.match(r"STATUS\.(\w+)\s*:\s*(Color\([^)]+\))", line)
            if m:
                existing_colors[m.group(1)] = m.group(2)

    # Обновляем color_by_type, сохраняя существующие цвета
    color_lines = "\tconst color_by_type : Dictionary = {\n"
    for name, _ in effects_data:
        upper_name = snake_to_upper(name)
        if upper_name in existing_colors:
            color = existing_colors[upper_name]
        else:
            color = generate_color_from_name(name)
        color_lines += f"\t\tSTATUS.{upper_name} : {color},\n"
    color_lines += "\t}\n"

    # Находим существующий color_by_type и заменяем
    content = re.sub(
        r"const color_by_type : Dictionary = \{[^}]*\}",
        color_lines.strip(),
        content,
        flags=re.DOTALL
    )

    # 3. Обновляем create_status()
    create_status_lines = "func create_status(type : STATUS) -> StatusEffectBase:\n"
    create_status_lines += "\tvar type_str = STATUS.find_key(type)\n"
    create_status_lines += "\tmatch(type):\n"

    for name, _ in effects_data:
        upper = snake_to_upper(name)
        class_name = f"StatusEffect{snake_to_pascal(name)}"
        create_status_lines += f"\t\tSTATUS.{upper}:\n"
        create_status_lines += f"\t\t\tvar status = {class_name}.new()\n"
        create_status_lines += f"\t\t\treturn status\n"

    create_status_lines += (
        "\n\tprinterr(\"unsupported status type\")\n"
        "\treturn StatusEffectBase.new(3)\n"
    )

    # Находим существующий create_status и заменяем
    content = re.sub(
        r"func create_status\(type : STATUS\) -> StatusEffectBase:.*?(?=\nfunc |\n#|\Z)",
        create_status_lines.strip(),
        content,
        flags=re.DOTALL
    )

    generator_path.write_text(content, encoding="utf-8")
    print(f"Updated: {generator_path}")


# ===== MAIN =====

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    with open(STATS_JSON_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)

    defaults = data.get("__default__", {})
    
    # Собираем данные для последующей модификации генератора
    effects_data = []

    for effect_name, config in data.items():
        # пропускаем служебные секции
        if effect_name.startswith("__"):
            continue
        
        merged_config = defaults.copy()
        merged_config.update(config)
        
        content, class_name, is_new = generate_effect(effect_name, merged_config)

        file_path = Path(OUTPUT_DIR) / f"{class_name}.gd"

        with open(file_path, "w", encoding="utf-8") as f:
            f.write(content)

        if is_new:
            print(f"Generated: {file_path}")
        else:
            print(f"Updated: {file_path} (constants + _init)")
        
        effects_data.append((effect_name, merged_config))

    # Модифицируем StatusEffectGenerator.gd
    update_generator_file(effects_data)


if __name__ == "__main__":
    main()