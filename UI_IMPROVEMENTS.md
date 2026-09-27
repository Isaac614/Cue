# Cue — UI & UX Improvement Guide

A comprehensive roadmap to elevate the visual hierarchy, micro-interactions, and user experience of **Cue**.

---

## 1. Executive Summary & Design Vision

**Cue** has a great modern aesthetic foundation: rounded typography (`.fontDesign(.rounded)`), custom color assets with dark-mode support, and modern glassmorphism (`.glassEffect`).

The primary opportunities for improvement lie in:
1. **Layout Resilience**: Replacing hardcoded pixel heights, fixed offsets, and heavy divider padding with adaptive, dynamic SwiftUI layouts.
2. **Information Architecture**: Separating day-to-day student tasks from one-time setup workflows.
3. **Micro-Interactions**: Introducing haptic feedback, fluid spring animations, and responsive loading states.
4. **Scannability**: Formatting dates relatively (e.g., *"Due in 2 hours"*, *"Tomorrow"*) and tagging courses with distinct visual badges.

---

## 2. Navigation & App Hierarchy (`ContentView.swift`)

### Current State
- Two tabs: `ListView` and `InputView`.
- Tab items only have SF Symbols (`leaf.fill`, `plus.app.fill`) without text labels.
- Uses deprecated `.accentColor(...)` instead of `.tint(...)`.
- `InputView` (Canvas calendar feed setup) occupies an entire tab slot permanently, even though users only configure it once.

### Recommendations
1. **Add Tab Labels**:
   Always include text beneath icons for accessibility and clarity:
   ```swift
   TabView {
       ListView(manager: manager)
           .tabItem {
               Label("Assignments", systemImage: "leaf.fill")
           }
       
       ClassesOverviewView()
           .tabItem {
               Label("Classes", systemImage: "books.vertical.fill")
           }
   }
   .tint(Color("AccentColor"))
   ```
2. **Move Setup / Sync to a Settings Sheet**:
   Instead of a dedicated tab, place Canvas calendar configuration in a settings or sync modal accessible from a top-trailing gear/refresh button in the navigation bar. This frees up the tab bar for high-frequency actions like **Today**, **Upcoming**, or **Courses**.

---

## 3. Main Dashboard (`ListView.swift`)

### Current Issues
* **Conflicting Backgrounds**: Lines 152–154 contain both `.background(Color("BackgroundColor"))` and `.background(.white)`, which overrides custom background theming.
* **Vertical Space Consumption**: If a student is enrolled in 5–7 classes, the vertical class capsules push the "Due Today" assignments completely below the fold.
* **Manual Spacing & Dividers**: Heavy padding on `Divider()` rows (`padding(.vertical, 35)`) creates unnatural gaps inside a plain `List`.
* **Sync Loading State**: The toolbar refresh icon doesn't reflect the background task when `manager.isLoading` is active.

### Proposed Enhancements

```
┌─────────────────────────────────────────────────────────┐
│  Classes                                     ⟳ Sync     │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐              │
│  │ ● CS 101  │ │ ● Math202 │ │ ● Bio 110 │  [+]         │
│  │ 2 due     │ │ All clear │ │ 1 due     │              │
│  └───────────┘ └───────────┘ └───────────┘              │
│                                                         │
│  Due Today                                              │
│  ┌───────────────────────────────────────────────────┐  │
│  │ ○ [CS 101] Homework 1              Due 11:59 PM › │  │
│  └───────────────────────────────────────────────────┘  │
│                                                         │
│  Upcoming                                               │
│  ┌───────────────────────────────────────────────────┐  │
│  │ ○ [Math 202] Problem Set 3           Wed 10/14  › │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

1. **Horizontal Class Carousel (Top Bar)**:
   Display classes in a horizontally scrolling header (`ScrollView(.horizontal, showsIndicators: false)`). Each card can show:
   - Course colored dot or accent border.
   - Custom display name (`classObject.userName`).
   - Active assignment count badge.
2. **Animated Sync Button**:
   ```swift
   ToolbarItem(placement: .topBarTrailing) {
       Button {
           Task { await manager.updateCalendar(context: modelContext, icsURL: icsLink) }
       } label: {
           if manager.isLoading {
               ProgressView()
                   .tint(Color("AccentColor"))
           } else {
               Image(systemName: "arrow.clockwise")
           }
       }
       .disabled(manager.isLoading)
   }
   ```
3. **Engaging Empty States**:
   Replace plain text with an illustrated state:
   ```swift
   VStack(spacing: 8) {
       Image(systemName: "sparkles")
           .font(.system(size: 28))
           .foregroundStyle(Color("AccentColor"))
       Text("All caught up for today!")
           .font(.headline)
       Text("No pending assignments due today.")
           .font(.subheadline)
           .foregroundStyle(Color("SubheadlineColor"))
   }
   .frame(maxWidth: .infinity)
   .padding(.vertical, 24)
   ```

---

## 4. Assignment Cards (`AssignmentListView.swift`)

### Current Issues
* Title concatenation is hardcoded as `Text("\(assignment.className) - \(assignment.name)")` with `.lineLimit(1)`, causing long titles to truncate early.
* Completion toggle lacks physical feedback.

### Proposed Redesign
1. **Two-Tier Header Hierarchy**:
   Place the course name in a subtle capsule/pill with the course's custom color, and allow the assignment name up to 2 lines.
2. **Haptic & Animation on Completion**:
   Add sensory feedback when checking off an assignment:
   ```swift
   Button {
       let generator = UIImpactFeedbackGenerator(style: .medium)
       generator.impactOccurred()
       withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
           assignment.markStatus()
       }
   } label: {
       Image(systemName: assignment.isComplete ? "checkmark.circle.fill" : "circle")
           .font(.title3)
           .foregroundStyle(assignment.isComplete ? Color("AccentColor") : assignment.parentClass.color)
           .symbolEffect(.bounce, value: assignment.isComplete)
   }
   ```
3. **Visual Completion State**:
   Apply subtle opacity reduction (`.opacity(assignment.isComplete ? 0.55 : 1.0)`) and an optional strikethrough so finished work cleanly recedes into the background.

---

## 5. Assignment Details (`AssignmentDetailsView.swift`)

### Current Issues
* The status badge uses fragile negative offsets:
  ```swift
  .offset(y: -16)
  .padding(.bottom, -16)
  ```
  This overlaps text when Dynamic Type or large accessibility text sizes are enabled.
* Fixed button height of `80` with a tall 200pt gradient overlay can obscure bottom scroll content on smaller devices (iPhone SE / mini).

### Proposed Fixes
1. **Clean Stack Alignment**:
   Replace manual offsets with natural `VStack(alignment: .leading, spacing: 10)` spacing.
2. **Modern Bottom Action Bar**:
   Use SwiftUI's native `.safeAreaInset(edge: .bottom)`:
   ```swift
   .safeAreaInset(edge: .bottom) {
       Button(action: {
           withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
               assignment.markStatus()
           }
       }) {
           HStack {
               Image(systemName: assignment.isComplete ? "arrow.uturn.backward.circle" : "checkmark.circle.fill")
               Text(!assignment.isComplete ? "Mark as Completed" : "Mark as Incomplete")
           }
           .font(.headline)
           .frame(maxWidth: .infinity)
           .frame(height: 52)
           .background(assignment.isComplete ? softRedGradient : buttonGradientGood)
           .foregroundStyle(Color("TextColor"))
           .clipShape(Capsule())
           .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
       }
       .padding(.horizontal, 20)
       .padding(.vertical, 12)
       .background(.ultraThinMaterial)
   }
   ```
3. **Course Accent Header**:
   Show a header badge with the course color so the user immediately knows which class the assignment belongs to.

---

## 6. Calendar Setup Flow (`InputView.swift` & `StepRow.swift`)

### Current Issues
* Students have to manually select, copy, switch apps, tap into the field, and paste.
* No link validation (students frequently paste the web URL instead of the `.ics` feed URL).
* `manager.errorMessage` is ignored even when calendar parsing fails.

### Proposed Additions
1. **"Paste from Clipboard" Action**:
   Add a quick paste button next to the text field:
   ```swift
   HStack {
       TextField("https://school.instructure.com/feeds/...", text: $icsLink)
       
       if let clip = UIPasteboard.general.string, clip.contains("ics") || clip.contains("http") {
           Button("Paste") {
               icsLink = clip
           }
           .font(.caption.bold())
           .padding(.horizontal, 10)
           .padding(.vertical, 6)
           .background(Color("AccentColor").opacity(0.15))
           .clipShape(Capsule())
       }
   }
   ```
2. **URL Validation State**:
   Display a green checkmark or warning indicator depending on whether the link matches a valid `.ics` or Canvas feed pattern.
3. **Dynamic Step Connector Line**:
   In `StepRow.swift`, the connecting vertical line is a fixed `Rectangle().frame(width: 2)`. Wrapping the step in an intrinsic layout ensures the line smoothly stretches regardless of text length.

---

## 7. Class Customization Sheet (`ClassColorPicker.swift`)

### Current Issues
* Title and dismiss button are manually laid out with `ZStack`, `HStack`, and `padding(.top, 90)`.
* Color swatches don't visually highlight which color is currently active.

### Proposed Modernization
1. **Standard Sheet Navigation**:
   Wrap the sheet in a standard `NavigationStack` with `.toolbar`:
   ```swift
   NavigationStack {
       VStack(spacing: 24) {
           // Display Name TextField
           // Preset Color Grid
       }
       .navigationTitle("Customize Class")
       .navigationBarTitleDisplayMode(.inline)
       .toolbar {
           ToolbarItem(placement: .confirmationAction) {
               Button("Done") { dismiss() }
                   .bold()
           }
       }
   }
   ```
2. **Active Color Selection Ring**:
   Overlay a ring or checkmark on the selected color:
   ```swift
   Circle()
       .fill(colorOption)
       .frame(width: 44, height: 44)
       .overlay {
           if isSelected {
               Circle()
                   .stroke(Color.primary, lineWidth: 3)
                   .padding(-4)
           }
       }
   ```

---

## 8. Prioritized Implementation Plan

| Priority | Feature / Fix | Impact | Effort |
| :--- | :--- | :--- | :--- |
| **P0** | Fix conflicting `.background(...)` in `ListView` & remove brittle negative offsets in `AssignmentDetailsView` | High (Fixes UI bugs) | 15 mins |
| **P1** | Add sync loading indicator (`manager.isLoading`) & paste button in `InputView` | High (User feedback) | 30 mins |
| **P2** | Add haptic feedback and spring animations on assignment completion | High (Feel & polish) | 30 mins |
| **P3** | Improve assignment card layout (2-line title + course tag instead of concatenated string) | Medium | 45 mins |
| **P4** | Convert `ClassColorPicker` to standard `NavigationStack` with selection indicators | Medium | 45 mins |
| **P5** | Redesign top of `ListView` with a horizontal class carousel or chip bar | High (Visual delight) | 1–2 hours |
