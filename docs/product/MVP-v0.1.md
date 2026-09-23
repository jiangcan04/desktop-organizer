# Desktop Organizer V0.1

## Problem

Mac users often work on multiple projects at the same time. Documents, PDFs, spreadsheets, screenshots, images, and temporary files can easily become mixed together on the desktop.

Traditional folders organize files mainly through file paths, while users often think about their work in terms of projects and tasks.

Desktop Organizer explores a spatial approach to file organization by introducing visual Zones that represent different projects or file purposes.

The first version focuses on three problems:

1. Files from different projects are mixed together.
2. Screenshots and saved images accumulate quickly.
3. Users lack a visual way to organize desktop files around their current working context.

## Core User Flow

The core V0.1 user flow is:

1. The user opens Desktop Organizer.
2. The user sees the main Workspace.
3. The Workspace contains default Screenshot and Inbox Zones.
4. The user creates a new Project Zone.
5. The user gives the Project Zone a name.
6. The user drags a file from Finder into the Zone.
7. The file appears inside the Zone.
8. The user clicks the file to open it with its original macOS application.
9. The user closes Desktop Organizer.
10. The user opens the application again.
11. The previously created Zone and its file relationships are restored.

V0.1 is considered successful when this complete workflow works reliably.

## MVP Features

### Workspace

* Display the main Desktop Organizer workspace.
* Display multiple Zones inside the workspace.

### Project Zone

* Create a new Project Zone.
* Give the Zone a name.
* Rename the Zone.
* Delete the Zone.
* Display files belonging to the Zone.

### File Interaction

* Drag files from Finder into a Zone.
* Store the relationship between the file and the Zone.
* Display the file name inside the Zone.
* Click a file to open the original file using macOS.

### Default Zones

Desktop Organizer will provide two default Zones:

* Screenshot Zone
* Inbox Zone

In V0.1, these Zones mainly establish the product structure. More advanced automatic organization will be added in later versions.

### Persistence

* Save created Zones.
* Save file-to-Zone relationships.
* Restore the workspace when the application is opened again.

## Not in V0.1

The following features are intentionally excluded from V0.1:

* AI-based file classification
* OCR
* Automatic screenshot monitoring
* Automatic movement of files
* Direct control of Finder desktop icon positions
* Desktop overlay mode
* Custom Zone colors and themes
* Cloud synchronization
* Collaboration
* Windows support
* iPhone or iPad support
* Advanced file search
* Tags
* Complex sorting rules

These features may be explored in later versions after the core Zone-based workflow has been validated.
