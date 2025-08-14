# Features Directory

This directory contains **feature-specific modules** for the application, following the **feature-first + MVVM** architecture pattern.

Each feature is **self-contained**, meaning it includes its own `data`, `domain`, and `ui` layers, along with tests.  
This approach improves scalability, testability, and code maintainability.

---

## Structure

features/
├── iou/ # IOU feature (debt/credit tracking)
│ ├── data/ # Data layer: repositories, DTOs, data sources
│ ├── domain/ # Domain layer: entities, use cases
│ ├── ui/ # UI layer: views, viewmodels, widgets
│ ├── tests/ # Unit & widget tests specific to this feature
│ └── iou_feature.dart # Public entry point (exports UI, routes, providers)
├── receipt/ # Receipt scanning & parsing feature
│ ├── data/
│ ├── domain/
│ ├── ui/
│ ├── tests/
│ └── receipt_feature.dart
└── ...

---

## Layer Responsibilities

### 1. **Data Layer**
- Responsible for data handling (local DB, network calls, caching).
- Implements repository interfaces defined in the domain layer.
- Converts raw data (DTOs) to domain entities.

**Example contents:**
- `repositories/`
- `datasources/`
- `models/` (DTOs)

---

### 2. **Domain Layer**
- Contains **pure business logic**, independent of Flutter or third-party frameworks.
- Defines **entities** and **use cases**.
- Only depends on abstractions (interfaces).

**Example contents:**
- `entities/`
- `usecases/`
- `repositories/` (interfaces)

---

### 3. **UI Layer**
- Contains all presentation logic and widgets.
- Uses **ViewModels** (with state management like Riverpod, Provider, etc.).
- No direct knowledge of the data layer — communicates via domain use cases.

**Example contents:**
- `screens/`
- `widgets/`
- `viewmodels/`

---

## Feature Guidelines
- **Self-contained:** No feature should depend on another feature’s internal classes.
- **Clear boundaries:** Only expose what is needed through the feature’s entry point file (`<feature>_feature.dart`).
- **Test everything:** Write unit tests for domain logic and widget tests for UI.
- **No cross-layer imports:** UI cannot directly import data layer classes; use the domain layer as the intermediary.

---

## Naming Conventions
- **Entities:** `PascalCase` (`IOU`, `ReceiptItem`)
- **Use Cases:** VerbNoun format (`AddIOU`, `GetReceipts`)
- **Repositories:** `<Entity>Repository`
- **ViewModels:** `<Entity>ViewModel`
- **DTOs:** `<Entity>Dto`

---

## Example Feature (IOU)


iou/
├── data/
│ ├── datasources/
│ │ └── iou_local_data_source.dart
│ ├── models/
│ │ └── iou_dto.dart
│ └── repositories/
│ └── iou_repository_impl.dart
├── domain/
│ ├── entities/
│ │ └── iou.dart
│ ├── repositories/
│ │ └── iou_repository.dart
│ └── usecases/
│ ├── add_iou.dart
│ └── get_ious.dart
├── ui/
│ ├── screens/
│ │ ├── iou_list_screen.dart
│ │ └── iou_form_screen.dart
│ ├── viewmodels/
│ │ └── iou_viewmodel.dart
│ └── widgets/
│ └── iou_card.dart
├── tests/
│ ├── iou_repository_impl_test.dart
│ ├── add_iou_test.dart
│ └── iou_viewmodel_test.dart
└── iou_feature.dart

---

## Testing Recommendations
- **Domain Layer:** Use `flutter_test` + `mocktail` to mock repository interfaces.
- **Data Layer:** Test repository implementations with in-memory or fake data sources.
- **UI Layer:** Use widget tests for key screens/components.

---

## References
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Reso Coder Clean Architecture](https://resocoder.com/flutter-clean-architecture)