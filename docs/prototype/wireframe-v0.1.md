# Desktop Organizer V0.1 — Low-Fidelity Wireframe

## 1. Main Workspace

```text
┌──────────────────────────────────────────────────────────┐
│ Desktop Organizer                                  ＋    │
│                                                          │
│ My Workspace                                             │
│                                                          │
│ ┌──────────────────────┐  ┌──────────────────────┐      │
│ │ 📁 Research      ⋯   │  │ 📸 Screenshots      │      │
│ │                      │  │                      │      │
│ │ report.docx          │  │ screenshot-01.png   │      │
│ │ data.xlsx            │  │ screenshot-02.png   │      │
│ │ paper.pdf            │  │                      │      │
│ │                      │  │                      │      │
│ │   Drop files here    │  │   Drop files here   │      │
│ └──────────────────────┘  └──────────────────────┘      │
│                                                          │
│ ┌──────────────────────┐                                │
│ │ 📥 Inbox             │                                │
│ │                      │                                │
│ │   Drop files here    │                                │
│ │                      │                                │
│ └──────────────────────┘                                │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

## 2. Main Components

### Top Bar

Contains:

* Application name: Desktop Organizer
* Add Zone button: `＋`

The Add Zone button is used to create a new Project Zone.

---

### Project Zone

Example:

```text
┌──────────────────────┐
│ 📁 Research      ⋯   │
│                      │
│ report.docx          │
│ data.xlsx            │
│ paper.pdf            │
│                      │
│   Drop files here    │
└──────────────────────┘
```

A Project Zone contains:

* Zone icon
* Zone name
* More menu `⋯`
* File list
* File drop area

---

### Screenshot Zone

```text
┌──────────────────────┐
│ 📸 Screenshots       │
│                      │
│ screenshot-01.png    │
│ screenshot-02.png    │
│                      │
│   Drop files here    │
└──────────────────────┘
```

The Screenshot Zone is created by the system.

Automatic screenshot detection is not included in V0.1.

---

### Inbox Zone

```text
┌──────────────────────┐
│ 📥 Inbox             │
│                      │
│   Drop files here    │
│                      │
└──────────────────────┘
```

Inbox is used for temporary files that have not yet been assigned to a project.

---

## 3. Create Zone Flow

User clicks:

```text
＋
```

A dialog appears:

```text
┌──────────────────────────────┐
│ Create Project Zone          │
│                              │
│ Name                         │
│ ┌──────────────────────────┐ │
│ │ Traditional Culture     │ │
│ └──────────────────────────┘ │
│                              │
│        Cancel     Create     │
└──────────────────────────────┘
```

After clicking `Create`, a new Project Zone appears in the Workspace.

---

## 4. Zone Menu

The user clicks:

```text
⋯
```

Menu:

```text
Rename
Delete
```

### Rename

Allows the user to change the Zone name.

### Delete

Deletes the Zone from the Workspace.

Deleting a Zone does not delete the original files from the Mac.

---

## 5. Empty State

When a Zone contains no files:

```text
┌──────────────────────┐
│ 📁 Research      ⋯   │
│                      │
│                      │
│   Drop files here    │
│                      │
│                      │
└──────────────────────┘
```

The empty state tells the user what action can be performed.

---

## 6. File State

After a file is dragged into a Zone:

```text
┌──────────────────────┐
│ 📁 Research      ⋯   │
│                      │
│ 📄 report.docx       │
│ 📊 data.xlsx         │
│ 📕 paper.pdf         │
│                      │
│   Drop files here    │
└──────────────────────┘
```

Clicking a file opens the original file with the appropriate macOS application.

Desktop Organizer does not copy the file in V0.1.

It stores the relationship between the original file and its Zone.

---

## 7. V0.1 Interaction Rules

1. `＋` creates a Project Zone.
2. Project Zone requires a name.
3. Files can be dragged from Finder into a Zone.
4. Clicking a file opens the original file.
5. `⋯` provides Rename and Delete actions.
6. Deleting a Zone does not delete original files.
7. Screenshot and Inbox Zones exist by default.
8. Zone information is restored when the application is reopened.

---

## 8. Core Screen States

V0.1 needs to support four important UI states.

### State A — First Launch

```text
Screenshots
Inbox
＋ Create Project
```

No Project Zones exist yet.

### State B — Empty Project

A Project Zone exists but contains no files.

### State C — Project With Files

The Zone contains one or more files.

### State D — Create Project Dialog

The user is entering the name of a new Project Zone.

These four states are sufficient for the first development version.
