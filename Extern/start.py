import os
import re

INPUT_DIR = "SURSA_GAME_DB_BINARY_PRINCIPALA"
OUTPUT_DIR = "SISTEMUL_EXTRAS_PRIN_DEFINE"
DEFINE_FILE = "GlobalDefines.h"

if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

def get_defines():
    defines = []
    if not os.path.exists(DEFINE_FILE):
        print(f"[Eroare] Nu am gasit fisierul {DEFINE_FILE}")
        return defines

    with open(DEFINE_FILE, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            match = re.match(r'#define\s+(\w+)', line.strip())
            if match:
                defines.append(match.group(1))
    return defines

def match_define_condition(line, defines):
    line = line.strip()

    # #ifdef / #ifndef
    for define in defines:
        if re.match(rf'#ifn?def\s+{define}\b', line):
            return True

    # #if defined(...) or !defined(...)
    defined_matches = re.findall(r'defined\s*\(\s*(\w+)\s*\)', line)
    if defined_matches:
        if "&&" in line:
            return all(d in defines for d in defined_matches)
        elif "||" in line:
            return any(d in defines for d in defined_matches)
        else:
            return all(d in defines for d in defined_matches)

    return False

def extract_blocks_from_file(filepath, relative_path, defines):
    with open(filepath, "r", encoding="utf-8", errors="ignore") as file:
        lines = file.readlines()

    output_lines = []
    i = 0
    block_index = 0

    while i < len(lines):
        line = lines[i]
        if match_define_condition(line, defines):
            start = i
            block_lines = [line]
            i += 1
            nesting = 1  # începem cu 1 pentru că avem deja un #ifdef/#ifndef/#if

            while i < len(lines):
                current = lines[i]
                stripped = current.strip()

                if re.match(r'#\s*(if|ifdef|ifndef)\b', stripped):
                    nesting += 1
                elif re.match(r'#\s*endif\b', stripped):
                    nesting -= 1

                block_lines.append(current)
                if nesting == 0:
                    break
                i += 1

            block_index += 1

            # Detectăm dacă are #else
            has_else = any("#else" in l for l in block_lines)
            if has_else:
                else_code = []
                in_else = False
                for bline in block_lines:
                    if "#else" in bline:
                        in_else = True
                        continue
                    if "#endif" in bline and in_else:
                        break
                    if in_else:
                        else_code.append(bline.strip())

                exists_in_file = any(ec in line for ec in else_code for line in lines)

                if exists_in_file:
                    output_lines.append("// Cauta blocul:\n")
                    output_lines.extend([f"{l}\n" for l in else_code])
                    output_lines.append("// Schimba cu:\n")
                    output_lines.extend(block_lines)
                else:
                    output_lines.append("// Adăugați acest bloc:\n")
                    output_lines.extend(block_lines)

            else:
                # Extragem contextul de sus
                context_lines = []
                found = 0
                j = start - 1
                while j >= 0 and found < 6:
                    line_context = lines[j].strip()
                    if line_context and not line_context.startswith("//") and line_context not in ["}", "{"]:
                        context_lines.insert(0, line_context)
                        found += 1
                    j -= 1

                if context_lines:
                    output_lines.append("// Cauta liniile:\n")
                    for cl in context_lines:
                        output_lines.append(f"//     {cl}\n")
                else:
                    output_lines.append("// Cauta linia: (context indisponibil)\n")

                output_lines.append("// Adauga dupa:\n")
                output_lines.extend(block_lines)

        i += 1

    return output_lines if block_index > 0 else None



def extract_direct_defines_from_file(filepath, relative_path, defines):
    with open(filepath, "r", encoding="utf-8", errors="ignore") as file:
        lines = file.readlines()

    output_lines = []
    for line in lines:
        match = re.match(r'#define\s+(\w+)', line.strip())
        if match:
            define = match.group(1)
            if define in defines:
                output_lines.append(f"// Adăugați acest define în fișierul vostru de define:\n#define {define}\n\n")

    return output_lines if output_lines else None

def extract_python_app_blocks(filepath, defines):
    with open(filepath, "r", encoding="utf-8", errors="ignore") as file:
        lines = file.readlines()

    output_blocks = []
    total_lines = len(lines)

    i = 0
    while i < total_lines:
        stripped_line = lines[i].strip()

        match = re.match(r'(?:#\s*)?if\s+app\.(\w+):', stripped_line)
        if not match:
            i += 1
            continue

        system_define = match.group(1)
        if system_define not in defines:
            i += 1
            continue

        # ----------------------------
        # 1. Extrage 6 linii deasupra
        # ----------------------------
        context_lines = []
        search_index = i - 1
        found = 0
        while search_index >= 0 and found < 6:
            line_above = lines[search_index].strip()
            if line_above and not line_above.startswith("#"):
                context_lines.insert(0, f"# {line_above}")
                found += 1
            search_index -= 1

        # ----------------------------
        # 2. Extrage blocul de cod
        # ----------------------------
        block_lines = [lines[i]]
        base_indent = len(lines[i]) - len(lines[i].lstrip())
        i += 1

        while i < total_lines:
            current_line = lines[i]
            if current_line.strip() == "":
                block_lines.append(current_line)
                i += 1
                continue

            indent = len(current_line) - len(current_line.lstrip())
            if indent > base_indent:
                block_lines.append(current_line)
                i += 1
            else:
                break

        # ----------------------------
        # 3. Salvează ca tutorial
        # ----------------------------
        output_blocks.append(f"#1.) Search function:\n")
        output_blocks.extend([line + "\n" for line in context_lines])
        output_blocks.append(f"#2.) Add after:\n")
        output_blocks.extend(block_lines)
        output_blocks.append("\n")

    return output_blocks if output_blocks else None









def process_all_files():
    defines = get_defines()
    if not defines:
        print("[!] Nu am gasit niciun #define")
        return

    print(f"[INFO] Încep scanarea în: {INPUT_DIR}")

    for root, dirs, files in os.walk(INPUT_DIR):
        for file in files:
            if file.endswith((".cpp", ".h", ".py")):
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, INPUT_DIR)
                output_file_path = os.path.join(OUTPUT_DIR, rel_path)

                output_blocks = None
                output_direct_defines = None
                output_python_blocks = None

                if file.endswith((".cpp", ".h")):
                    output_blocks = extract_blocks_from_file(full_path, rel_path, defines)
                    output_direct_defines = extract_direct_defines_from_file(full_path, rel_path, defines)

                if file.endswith(".py"):
                    output_python_blocks = extract_python_app_blocks(full_path, defines)

                # Salvăm doar dacă există ceva
                if output_blocks or output_direct_defines or output_python_blocks:
                    os.makedirs(os.path.dirname(output_file_path), exist_ok=True)

                    with open(output_file_path, "w", encoding="utf-8") as outf:
                        if output_direct_defines:
                            outf.writelines(output_direct_defines)
                        if output_blocks:
                            outf.writelines(output_blocks)
                        if output_python_blocks:
                            # Adaugă comentariu cu fișierul sursă
                            outf.write(f"# [from: {rel_path}]\n")
                            outf.writelines(output_python_blocks)

                    print(f"[✔] Scris: {output_file_path}")
                else:
                    print(f"[ ] Nimic de extras din: {rel_path}")




process_all_files()
