#!/usr/bin/env bash
# init-rename.sh — Rinomina il template da "myapp" al nome del progetto reale.
# Da lanciare UNA SOLA VOLTA dopo aver clonato il repo creato dal template.
#
# Cosa fa:
#   1. sed ricorsivo "myapp" → "<nuovo-nome>" in tutti i file testuali (esclusi target/.idea/.git/...)
#   2. Rinomina cartelle Java package: src/main/java/it/myapp → src/main/java/it/<nome>
#   3. Si auto-cancella alla fine (è un'operazione one-shot)
#
# Uso:
#   ./init-rename.sh <nuovo-nome>
#   es: ./init-rename.sh tracker

set -euo pipefail

NEW_NAME="${1:?Uso: $0 <nuovo-nome>. Esempio: $0 tracker}"
OLD_NAME="myapp"

if [[ "$NEW_NAME" == "$OLD_NAME" ]]; then
  echo "Il nome è già '$NEW_NAME'. Niente da fare."
  exit 0
fi

# Validazione: solo lowercase, numeri, trattini, deve iniziare con lettera
if [[ ! "$NEW_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
  echo "ERRORE: '$NEW_NAME' non valido."
  echo "Usa solo lowercase + numeri + trattini, deve iniziare con una lettera."
  echo "Esempi validi: tracker, my-app, listino-2026"
  exit 1
fi

# Java package non accetta trattini → convertiamo a underscore (o senza) per i percorsi Java
JAVA_NAME="${NEW_NAME//-/}"   # rimuove i trattini (es. "my-app" → "myapp")

echo "Rinomino '$OLD_NAME' → '$NEW_NAME' (Java package: it.${JAVA_NAME})..."

# 1. sed in tutti i file testuali
find . -type f \
  -not -path './.git/*' \
  -not -path './node_modules/*' \
  -not -path './target/*' \
  -not -path './dist/*' \
  -not -path './build/*' \
  -not -path './.idea/*' \
  -not -name 'init-rename.sh' \
  -exec sed -i "s/${OLD_NAME}/${NEW_NAME}/g" {} +

# Sostituisci anche eventuali riferimenti al package Java (con underscore se serve)
if [[ "$JAVA_NAME" != "$NEW_NAME" ]]; then
  find . -type f \( -name '*.java' -o -name '*.properties' -o -name 'pom.xml' \) \
    -not -path './target/*' \
    -exec sed -i "s/it\.${NEW_NAME}/it.${JAVA_NAME}/g" {} +
fi

# 2. Rinomina cartelle package Java
if [[ -d "src/main/java/it/${OLD_NAME}" ]]; then
  mv "src/main/java/it/${OLD_NAME}" "src/main/java/it/${JAVA_NAME}"
  echo "  Rinominato src/main/java/it/${OLD_NAME} → src/main/java/it/${JAVA_NAME}"
fi
if [[ -d "src/test/java/it/${OLD_NAME}" ]]; then
  mv "src/test/java/it/${OLD_NAME}" "src/test/java/it/${JAVA_NAME}"
  echo "  Rinominato src/test/java/it/${OLD_NAME} → src/test/java/it/${JAVA_NAME}"
fi

# 3. Auto-cancellazione
rm -f -- "$0"

echo ""
echo "✅ Rinominato. Ora puoi:"
echo "   git add -A && git commit -m 'init: rename ${OLD_NAME} → ${NEW_NAME}'"
echo "   git push"
echo ""
echo "Note: questo script si è auto-cancellato (era one-shot)."
