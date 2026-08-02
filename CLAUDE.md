## General Rules

- Act based on facts. If you're unsure, verify the information.
state your assumptions. ask when unsure. never guess.

- Simplicity first
write the minimum code that solves the problem.
no abstractions nobody asked for.

- Surgical changes
don't touch code unrelated to the request.
every changed line must trace back to what was asked.

- Goal-driven execution
turn vague instructions into verifiable success criteria
before writing a single line.

## Implementation Rules

- When editing `.st` files, actively consult the `smalltalk-developer` skill.
  - In particular, the style guide section is important.
- When debugging Smalltalk code, consult the `smalltalk-debugger` skill.
  - In particular, focus on the troubleshooting and UI debugging sections.
- Always write documentation in English.
- Follow TDD.
- Do not make grand, too-deep plans. Just proceed step by step with user feedback.

## Code Review Rules

- Name is important. Always check class/method/variable names are intentional revealing. (We do not care long name)
- Always Keep DRY principal to make the code simple and clean
- In adding a new feature, it is essential to verify that it has already been tested by unit tests.
