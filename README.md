# Wallet UNSAAC

Aplicativo móvil de finanzas personales para estudiantes, desarrollado en Flutter.
Proyecto del curso **Desarrollo de Software II (IF616BIN)** — Escuela Profesional de
Ingeniería Informática y de Sistemas, Universidad Nacional de San Antonio Abad del Cusco
(UNSAAC). Semestre académico 2026-II.

- **Estudiante:** Nayeli Constantina Labra Huaita
- **Código:** 195048
- **Docente:** Mtro. Ing. Yover Collantes Valer
- **Entrega:** Unidad II — Sesión 1 (cuatro retos individuales)

## Qué hace la app

Muestra el saldo, los ingresos, los egresos y la lista de movimientos de una billetera
personal. Los datos de demostración viven en memoria y simulan una pequeña latencia de red.

## Retos de la Sesión 1

| Reto | Descripción | Archivos principales |
|---|---|---|
| 1 | **Tema persistente**: el modo claro / oscuro / sistema se guarda con `shared_preferences` y se lee antes de `runApp`. | `core/theme/theme_preferences.dart`, `theme_cubit.dart`, `main.dart` |
| 2 | **Saldo privado**: un botón de ojo oculta y muestra todos los importes mediante un `PrivacyCubit`. | `presentation/state/privacy_cubit.dart`, `widgets/balance_card.dart`, `widgets/movement_tile.dart` |
| 3 | **Estados de carga, éxito y error**: un `BalanceCubit` con estados sellados reemplaza al `FutureBuilder`, con botón Reintentar. | `presentation/state/balance_cubit.dart`, `balance_state.dart` |
| 4 | **Color semilla configurable**: cuatro colores aplicados con `ColorScheme.fromSeed` en modo claro y oscuro. | `core/theme/app_theme.dart`, `theme_state.dart`, `pages/wallet_home_page.dart` |

## Arquitectura

Arquitectura por capas con gestión de estado mediante **Cubit** (`flutter_bloc`):

```
lib/
├── main.dart              # Punto de entrada: lee el tema guardado antes de runApp
├── app.dart               # Raíz de la app e inyección de dependencias
├── core/
│   ├── config/            # Inicialización defensiva de Firebase
│   ├── theme/             # Tema, modo, color semilla y almacenamiento
│   └── utils/             # Formato de moneda y fechas
└── features/wallet/
    ├── domain/            # Entidades y contrato del repositorio
    ├── data/              # Repositorio en memoria
    └── presentation/      # Cubits, estados, widgets y pantalla principal
```

## Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (canal estable; desarrollado
  con la versión 3.47.5)
- Android Studio con un emulador (AVD) o un dispositivo Android. También puede ejecutarse
  en Chrome para una prueba rápida.

## Cómo ejecutarlo

```bash
git clone https://github.com/Nayelilh/wallet_unsaac.git
cd wallet_unsaac
flutter pub get
flutter run
```

Para ejecutarlo en el navegador: `flutter run -d chrome`.

## Pruebas y análisis

```bash
flutter analyze   # análisis estático
flutter test      # pruebas unitarias y de widgets
```

Pruebas incluidas, una por reto:

- `test/theme_persistence_test.dart` — Reto 1
- `test/privacy_test.dart` — Reto 2
- `test/balance_cubit_test.dart` — Reto 3
- `test/theme_seed_test.dart` — Reto 4

## Firebase

El proyecto incluye la preparación para Firebase, pero **no requiere configuración** para
funcionar. Mientras `lib/firebase_options.dart` conserve los valores `REEMPLAZAR_...`, la
app arranca en modo local y muestra "Firebase: no configurado (modo local)". No es un error.

Para conectarla a un proyecto propio, ejecuta `flutterfire configure`. No subas
credenciales reales a un repositorio público.

## Dependencias principales

`flutter_bloc`, `equatable`, `shared_preferences`, `firebase_core` y, para pruebas,
`bloc_test`.
