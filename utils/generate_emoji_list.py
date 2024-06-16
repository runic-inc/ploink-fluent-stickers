import requests
import json
import os
from pathlib import Path

def fetch_latest_emojis():
    # CLDR emoji annotations url
    url = "https://unicode.org/Public/emoji/latest/emoji-test.txt"
    
    response = requests.get(url)
    if response.status_code != 200:
        raise Exception("Failed to fetch emoji data from Unicode")

    emoji_data = response.text
    emoji_dict = {}
    
    for line in emoji_data.splitlines():
        if line.startswith("#") or line.strip() == "":
            continue
        
        parts = line.split(';')
        if len(parts) < 2:
            continue

        pieces = parts[1].split('#')
        if len(pieces) < 2:
            continue
        if pieces[0].strip() != "fully-qualified":
            continue

        bits = pieces[1].split()
        if len(bits) < 3:
            continue

        emoji = bits[0]
        description = bits[2:]
        cldr_short_name = ' '.join(description).replace(":", "").replace(" ", "_").lower()
        
        emoji_dict[emoji] = cldr_short_name
    
    return emoji_dict


def check_files_exist(emoji_list, directory_path):
    directory_path = Path(directory_path)
    matches = {}
    non_matches = {}

    files_in_directory = {f.name.lower() for f in directory_path.iterdir() if f.is_file()}
    
    for emoji, description in emoji_list.items():
        file_name = f"{description}.png".lower()
        if file_name not in files_in_directory:
            non_matches[emoji] = description
        else:
            matches[emoji] = description
    
    return matches, non_matches


def save_to_json(data, filename):
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)


if __name__ == "__main__":
    directory_path = '../assets'
    latest_emojis = fetch_latest_emojis()
    comparison = check_files_exist(latest_emojis, directory_path)

    save_to_json(comparison[0], "../generated/emojis.json")
    save_to_json(comparison[1], "../generated/missing.json")

    print("Latest Unicode emoji list saved to emojis.json (non-matches saved to missing.json)")
