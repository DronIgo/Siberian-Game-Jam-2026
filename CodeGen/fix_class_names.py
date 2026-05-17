import os
import re

dirs = [
    'Scripts/Logic/Fight/Actions/OrganActions',
    'Scripts/Logic/Fight/Actions/PlayerActions', 
    'Scripts/Logic/Fight/Actions/ShopActions'
]

for d in dirs:
    for f in os.listdir(d):
        if not f.endswith('.gd') or f.endswith('.gd.uid'):
            continue
        path = os.path.join(d, f)
        with open(path, 'r', encoding='utf-8') as file:
            content = file.read()
        
        # Replace multiple L's at end of class_name with single L
        new_content = re.sub(r'(class_name Action\w+?)(L)(L+)', r'\1\2', content)
        
        if new_content != content:
            with open(path, 'w', encoding='utf-8') as file:
                file.write(new_content)
            print(f'Fixed: {path}')
        else:
            print(f'OK: {path}')