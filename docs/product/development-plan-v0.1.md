# Desktop Organizer V0.1 — Development Plan

## Development Principle

Desktop Organizer will be developed incrementally.

Each development task should:

- focus on one small feature;
- produce a visible or testable result;
- be tested before moving forward;
- create a Git commit after successful completion.

The goal is not to generate the entire application with AI at once.

The goal is to build and understand the product step by step.

## Phase 1 — Project Setup

### Task 1.1 — Create macOS Project

Create a new macOS application using:

- Swift
- SwiftUI

Success criteria:

- The project builds successfully.
- The application window can open.
- The default SwiftUI interface is visible.

Git commit:

`Create initial macOS SwiftUI project`

---

## Phase 2 — Static Workspace

### Task 2.1 — Create Main Workspace

Create the basic Desktop Organizer window.

Display:

- Desktop Organizer title
- My Workspace title
- Add button

Success criteria:

- The main structure appears correctly.
- No interactive functionality is required yet.

Git commit:

`Add main workspace layout`

### Task 2.2 — Create Zone Component

Create a reusable Zone UI component.

The first version should display:

- Zone icon
- Zone name
- empty state text

Success criteria:

- One Zone can be displayed correctly.
- The same component can be reused.

Git commit:

`Add reusable zone component`

### Task 2.3 — Display Default Zones

Display two default Zones:

- Screenshots
- Inbox

Success criteria:

- Both Zones appear when the application opens.

Git commit:

`Add default workspace zones`

---

## Phase 3 — Zone Data

### Task 3.1 — Create Zone Model

Create a basic Zone data model.

A Zone should contain at least:

- id
- name
- type
- files

Success criteria:

- The UI can display Zone information from data instead of hard-coded text.

Git commit:

`Add zone data model`

### Task 3.2 — Create Project Zone

Allow the user to create a new Project Zone.

Success criteria:

- Clicking the Add button opens a creation interface.
- The user can enter a Zone name.
- The new Zone appears in the Workspace.

Git commit:

`Add project zone creation`

### Task 3.3 — Rename and Delete Zone

Add:

- Rename
- Delete

Success criteria:

- A Project Zone can be renamed.
- A Project Zone can be removed.
- Removing the Zone does not delete Mac files.

Git commit:

`Add zone management actions`

---

## Phase 4 — File Interaction

### Task 4.1 — Drag File Into Zone

Allow files to be dragged from Finder into a Zone.

Success criteria:

- A dragged file is recognized.
- The file name appears inside the Zone.

Git commit:

`Add file drag and drop`

### Task 4.2 — Open File

Allow the user to click a file displayed in a Zone.

Success criteria:

- macOS opens the original file using the appropriate application.

Git commit:

`Add file open action`

---

## Phase 5 — Persistence

### Task 5.1 — Save Workspace

Save:

- Project Zones
- Zone names
- file-to-Zone relationships

Success criteria:

- Changes remain available after the application is closed.

Git commit:

`Add workspace persistence`

### Task 5.2 — Restore Workspace

Restore saved data when Desktop Organizer launches.

Success criteria:

- Previously created Zones return.
- Previously added files appear in the correct Zone.

Git commit:

`Restore saved workspace`

---

## V0.1 Completion Test

Desktop Organizer V0.1 is complete when the following workflow succeeds:

1. Open Desktop Organizer.
2. See Screenshot and Inbox Zones.
3. Create a Project Zone named `Research`.
4. Drag a real file from Finder into Research.
5. See the file inside the Zone.
6. Click the file and open it.
7. Close Desktop Organizer.
8. Open Desktop Organizer again.
9. Confirm that Research and its file are still present.

If this workflow works reliably, the V0.1 MVP is complete.