# NOTES

## Level 1 — Lift it up
- Constructors touched to pass `total` to the badge: **2** (`BooksScreen`, `CartBadge`)
- Files touched: **3** (`main.dart`, `books_screen.dart`, `cart_badge.dart`)
- `BooksScreen` never uses `total` itself — it only forwards it.
- Console lines after ONE tap on Add: **__** (fill in: `BooksScreen build` + one `row ...` per book)

## Level 3 — provider errors
- Loud (`context.watch<Cart>().add(b)` in onPressed):
  > (paste the full error text here)
- Silent (`context.read<Cart>().count` in the badge): no error, compiles, runs —
  the badge stays at 0 forever because nothing subscribed.

## Level 4 — rebuild counts (3 presses of + on a cart row)
- Badge with `watch`:  **__** (expected 3)
- Badge with `select`: **__** (expected 0)

## Where does it live?
- The cart — **provided**: several screens read and change it; it must outlive any one route.
- Search text in the Books AppBar — **ephemeral**: only that screen and its list use it.
- Total expanded/collapsed on Cart screen — **ephemeral**: a purely visual detail of one widget.
- Theme mode — **lifted/provided**: `MaterialApp` itself depends on it, so it lives above it.
