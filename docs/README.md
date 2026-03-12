# 📚 Documentation Index

> Complete documentation for Flutter Clean Architecture + BLoC

---

## 📖 Main Guides

| Document                                         | Description                                                                                        |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------- |
| [🏛 ARCHITECTURE_GUIDE.md](ARCHITECTURE_GUIDE.md) | **Complete architecture guide** - Everything you need to understand and implement the architecture |
| [📋 QUICK_REFERENCE.md](QUICK_REFERENCE.md)      | **Copy-paste templates** - Ready-to-use code templates for rapid development                       |

---

## 📂 Layer Guides

Detailed documentation for each architectural layer:

| Layer           | Document                                              | Description                                     |
| --------------- | ----------------------------------------------------- | ----------------------------------------------- |
| 📦 Data         | [DATA_LAYER.md](layers/DATA_LAYER.md)                 | Models, DataSources, Repository implementations |
| 🧠 Domain       | [DOMAIN_LAYER.md](layers/DOMAIN_LAYER.md)             | Entities, Repository interfaces, UseCases       |
| 🎨 Presentation | [PRESENTATION_LAYER.md](layers/PRESENTATION_LAYER.md) | BLoC, Events, States, Pages, Widgets            |

---

## 🗂 Folder Structure

```
docs/
├── README.md                   # This file
├── ARCHITECTURE_GUIDE.md       # Complete architecture guide
├── QUICK_REFERENCE.md          # Copy-paste templates
└── layers/
    ├── DATA_LAYER.md           # Data layer documentation
    ├── DOMAIN_LAYER.md         # Domain layer documentation
    └── PRESENTATION_LAYER.md   # Presentation layer documentation
```

---

## 🎯 Quick Links by Task

### Starting a New Project

1. Read [ARCHITECTURE_GUIDE.md](ARCHITECTURE_GUIDE.md) overview
2. Use [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for initial setup

### Adding a New Feature

1. Start with [DOMAIN_LAYER.md](layers/DOMAIN_LAYER.md) - Define entities & use cases
2. Then [DATA_LAYER.md](layers/DATA_LAYER.md) - Implement data access
3. Finally [PRESENTATION_LAYER.md](layers/PRESENTATION_LAYER.md) - Build the UI

### Quick Copy-Paste

- Use [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for all templates

---

## ✅ New Feature Checklist

```
□ Domain Layer
  □ Create Entity (domain/entities/)
  □ Create Repository interface (domain/repositories/)
  □ Create UseCases (domain/usecases/)

□ Data Layer
  □ Create Model (data/models/)
  □ Create Remote DataSource (data/datasources/)
  □ Create Local DataSource (data/datasources/) - if caching
  □ Create Repository Implementation (data/repositories/)

□ Presentation Layer
  □ Create Events (presentation/bloc/)
  □ Create States (presentation/bloc/)
  □ Create BLoC (presentation/bloc/)
  □ Create Pages (presentation/pages/)
  □ Create Widgets (presentation/widgets/) - if needed

□ Integration
  □ Register in DI (core/di/injection_container.dart)
  □ Add routes (core/router/app_router.dart)
  □ Add BLoC provider (app.dart)
  □ Create barrel export (features/[feature]/[feature].dart)
```

---

## 💡 Tips

1. **Start from Domain** - Always define your business logic first
2. **Use templates** - Copy from QUICK_REFERENCE.md and modify
3. **Keep it simple** - Don't over-engineer, follow existing patterns
4. **Test as you go** - Write tests alongside your code
5. **Document as needed** - Update docs when patterns evolve

---

> 📌 Keep this documentation updated as the project evolves!
