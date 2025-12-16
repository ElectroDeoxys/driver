from pathlib import Path
import re


def get_unnamed_labels(asm_files):
    labels = set()

    for asm_file in asm_files:
        with open(asm_file, "r") as file:
            body = file.read()
            for match in re.finditer(r"\$([cd][a-f0-9]{3})\b", body):
                labels.add(int(match[1], 16))
            for match in re.finditer(r"\$(ff[8-9a-f][a-f0-9])\b", body):
                labels.add(int(match[1], 16))

    return labels

def add_label(body: str, label: int):
    for match in re.finditer(r"\tds \$(....) - \$(....)\n", body):
        start = int(match[2], 16)
        end = int(match[1], 16)

        start_idx = match.start()
        end_idx = match.end()

        label_str = f"w{label:x}:: db ; {label:x}\n"

        if label == start:
            # simply add label before gap
            label_next = label + 1
            gap = f"\tds ${end:x} - ${label_next:x}\n"
            return body[:start_idx] + label_str + "\n" + gap + body[end_idx:]

        elif label == end - 1:
            # simply add label after gap
            gap = f"\tds ${label:x} - ${start:x}\n"
            return body[:start_idx] + gap + "\n" + label_str + body[end_idx:]

        elif label > start and label < end - 1:
            # impute value
            label_next = label + 1

            gap_prev = f"\tds ${label:x} - ${start:x}\n"
            gap_next = f"\tds ${end:x} - ${label_next:x}\n"

            return body[:start_idx] + gap_prev + "\n" + label_str + "\n" + gap_next + body[end_idx:]
        
    return None


if __name__ == "__main__":
    ram_files = list(Path('src/ram').rglob('*.asm'))

    asm_files = []
    for asm_file in Path('src').rglob('*.asm'):
        if asm_file in ram_files:
            continue
        asm_files.append(asm_file)

    labels = get_unnamed_labels(asm_files)

    for label in labels:
        found = False

        for ram_file in ram_files:
            with open(ram_file, "r+") as file:
                body = file.read()
                body = add_label(body, label)

                if body is not None:
                    # clean any "0 diffs"
                    body = re.sub(r"\tds \$(....) - \$\1\n\n", "", body)

                    file.seek(0)
                    file.write(body)
                    file.truncate()

                    found = True
                    break

        if not found:
            raise ValueError(f"${label:x} not found!")

    for asm_file in asm_files:
        with open(asm_file, "r+") as file:
            body = file.read()
            body = re.sub(r"\$([cd][a-f0-9]{3})\b", lambda m: "w" + m[1], body)
            body = re.sub(r"\$(ff[8-9a-f][a-f0-9])\b", lambda m: "h" + m[1], body)

            file.seek(0)
            file.write(body)
            file.truncate()
