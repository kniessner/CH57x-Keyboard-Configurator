#!/usr/bin/env python3
"""
Terminal UI for the CH57x keyboard toolkit.
"""

from __future__ import annotations

import curses
import shutil
import subprocess
import textwrap
from pathlib import Path

import yaml

PROJECT_ROOT = Path(__file__).resolve().parent
CONFIG_PATH = PROJECT_ROOT / "keyboard_config.yaml"
PRESETS_DIR = PROJECT_ROOT / "presets"


class KeyboardTUI:
    def __init__(self) -> None:
        self.actions = [
            ("Check keyboard connection", self.check_keyboard),
            ("Show current config summary", self.show_current_config),
            ("Apply preset to keyboard_config.yaml", self.apply_preset),
            ("Validate current config", self.validate_config),
            ("Upload current config", self.upload_config),
            ("Create timestamped backup", self.backup_config),
            ("Test button layout", self.test_layout),
            ("Launch web GUI", self.launch_gui),
            ("Quit", self.quit_app),
        ]
        self.selected_action = 0
        self.running = True
        self.status_lines = [
            "Use ↑/↓ to move, Enter to run, q to quit.",
            "This TUI wraps the existing keyboard.sh workflow.",
        ]

    def run(self, stdscr: curses.window) -> None:
        curses.curs_set(0)
        stdscr.keypad(True)

        while self.running:
            self.draw(stdscr)
            key = stdscr.getch()

            if key in (ord("q"), ord("Q")):
                self.running = False
            elif key == curses.KEY_UP:
                self.selected_action = (self.selected_action - 1) % len(self.actions)
            elif key == curses.KEY_DOWN:
                self.selected_action = (self.selected_action + 1) % len(self.actions)
            elif key in (curses.KEY_ENTER, 10, 13):
                _, handler = self.actions[self.selected_action]
                handler(stdscr)

    def draw(self, stdscr: curses.window) -> None:
        stdscr.erase()
        height, width = stdscr.getmaxyx()
        title = "CH57x Keyboard Toolkit TUI"
        stdscr.addnstr(1, 2, title, width - 4, curses.A_BOLD)
        stdscr.hline(2, 2, ord("="), max(0, width - 4))

        stdscr.addnstr(4, 2, "Actions", width - 4, curses.A_UNDERLINE)
        for index, (label, _) in enumerate(self.actions):
            attr = curses.A_REVERSE if index == self.selected_action else curses.A_NORMAL
            stdscr.addnstr(6 + index, 4, label, width - 8, attr)

        info_x = max(40, width // 2)
        if info_x < width - 20:
            self.draw_sidebar(stdscr, info_x, width - info_x - 2, height)

        status_y = min(height - 6, 6 + len(self.actions) + 2)
        stdscr.addnstr(status_y, 2, "Status", width - 4, curses.A_UNDERLINE)
        for offset, line in enumerate(self.status_lines[: max(1, height - status_y - 2)]):
            stdscr.addnstr(status_y + 1 + offset, 4, line, width - 8)

        stdscr.refresh()

    def draw_sidebar(self, stdscr: curses.window, x: int, width: int, height: int) -> None:
        stdscr.addnstr(4, x, "Current Config", width, curses.A_UNDERLINE)
        for index, line in enumerate(self.get_config_summary(width)):
            y = 6 + index
            if y >= height - 8:
                break
            stdscr.addnstr(y, x, line, width)

        doc_y = min(height - 5, 18)
        if doc_y > 6:
            stdscr.addnstr(doc_y, x, "Presets", width, curses.A_UNDERLINE)
            for offset, preset in enumerate(self.list_presets()[: max(1, height - doc_y - 2)]):
                stdscr.addnstr(doc_y + 1 + offset, x, f"- {preset}", width)

    def get_config_summary(self, width: int) -> list[str]:
        try:
            with CONFIG_PATH.open() as handle:
                config = yaml.safe_load(handle) or {}
        except Exception as exc:
            return [f"Failed to load config: {exc}"]

        rows = config.get("rows", "?")
        columns = config.get("columns", "?")
        knobs = config.get("knobs", "?")
        lines = [
            f"Layout: {rows}x{columns}, knobs: {knobs}",
            f"Orientation: {config.get('orientation', 'unknown')}",
        ]

        layers = config.get("layers", [])
        if layers:
            buttons = layers[0].get("buttons", [])
            lines.append("Layer 1:")
            for row in buttons[:3]:
                rendered = " | ".join(str(item) for item in row)
                lines.extend(textwrap.wrap(rendered, width=max(10, width - 2)) or [""])
            knobs_config = layers[0].get("knobs", [])
            if knobs_config:
                lines.append("Knobs:")
                for idx, knob in enumerate(knobs_config[:2], start=1):
                    rendered = f"K{idx}: cw={knob.get('cw')} ccw={knob.get('ccw')} press={knob.get('press')}"
                    lines.extend(textwrap.wrap(rendered, width=max(10, width - 2)) or [""])

        return lines

    def list_presets(self) -> list[str]:
        return sorted(path.stem for path in PRESETS_DIR.glob("*.yaml"))

    def set_status(self, message: str) -> None:
        self.status_lines = textwrap.wrap(message, width=90) or [message]

    def run_command(self, command: list[str]) -> tuple[int, str]:
        result = subprocess.run(
            command,
            cwd=PROJECT_ROOT,
            capture_output=True,
            text=True,
        )
        output = (result.stdout or "").strip()
        error = (result.stderr or "").strip()
        combined = "\n".join(part for part in [output, error] if part).strip()
        return result.returncode, combined

    def confirm(self, stdscr: curses.window, prompt: str) -> bool:
        self.set_status(f"{prompt} Press y to confirm, any other key to cancel.")
        self.draw(stdscr)
        key = stdscr.getch()
        confirmed = key in (ord("y"), ord("Y"))
        self.set_status("Confirmed." if confirmed else "Cancelled.")
        return confirmed

    def choose_from_list(self, stdscr: curses.window, title: str, options: list[str]) -> str | None:
        index = 0
        while True:
            stdscr.erase()
            height, width = stdscr.getmaxyx()
            stdscr.addnstr(1, 2, title, width - 4, curses.A_BOLD)
            stdscr.hline(2, 2, ord("="), max(0, width - 4))
            stdscr.addnstr(4, 2, "Use ↑/↓ to move, Enter to select, q to cancel.", width - 4)

            for row, option in enumerate(options):
                attr = curses.A_REVERSE if row == index else curses.A_NORMAL
                stdscr.addnstr(6 + row, 4, option, width - 8, attr)

            stdscr.refresh()
            key = stdscr.getch()
            if key in (ord("q"), ord("Q"), 27):
                return None
            if key == curses.KEY_UP:
                index = (index - 1) % len(options)
            elif key == curses.KEY_DOWN:
                index = (index + 1) % len(options)
            elif key in (curses.KEY_ENTER, 10, 13):
                return options[index]

    def check_keyboard(self, stdscr: curses.window) -> None:
        code, output = self.run_command(["./keyboard.sh", "check"])
        if code == 0:
            self.set_status(output or "Keyboard detected.")
        else:
            self.set_status(output or "Keyboard check failed.")

    def show_current_config(self, stdscr: curses.window) -> None:
        summary = self.get_config_summary(80)
        self.status_lines = summary

    def apply_preset(self, stdscr: curses.window) -> None:
        presets = self.list_presets()
        if not presets:
            self.set_status("No presets found.")
            return

        choice = self.choose_from_list(stdscr, "Select Preset", presets)
        if not choice:
            self.set_status("Preset selection cancelled.")
            return

        if not self.confirm(stdscr, f"Apply preset '{choice}' to keyboard_config.yaml?"):
            return

        source = PRESETS_DIR / f"{choice}.yaml"
        shutil.copyfile(source, CONFIG_PATH)
        self.set_status(f"Applied preset '{choice}' to keyboard_config.yaml.")

    def validate_config(self, stdscr: curses.window) -> None:
        code, output = self.run_command(["./keyboard.sh", "validate"])
        self.set_status(output if output else ("Config is valid." if code == 0 else "Validation failed."))

    def upload_config(self, stdscr: curses.window) -> None:
        if not self.confirm(stdscr, "Upload the current config to the keyboard?"):
            return
        code, output = self.run_command(["./keyboard.sh", "upload"])
        self.set_status(output if output else ("Upload finished." if code == 0 else "Upload failed."))

    def backup_config(self, stdscr: curses.window) -> None:
        code, output = self.run_command(["./keyboard.sh", "backup"])
        self.set_status(output if output else ("Backup created." if code == 0 else "Backup failed."))

    def test_layout(self, stdscr: curses.window) -> None:
        if not self.confirm(stdscr, "Upload the temporary test layout?"):
            return
        code, output = self.run_command(["./keyboard.sh", "test"])
        self.set_status(output if output else ("Test layout command finished." if code == 0 else "Test layout failed."))

    def launch_gui(self, stdscr: curses.window) -> None:
        code, output = self.run_command(["./keyboard.sh", "gui-start"])
        self.set_status(output if output else ("GUI start command finished." if code == 0 else "Failed to start GUI."))

    def quit_app(self, stdscr: curses.window) -> None:
        self.running = False


def main() -> None:
    curses.wrapper(KeyboardTUI().run)


if __name__ == "__main__":
    main()
