#!/bin/bash

echo "======================================"
echo " # QA Project - Testes de Qualidade "
echo "======================================"

# Caminho absoluto para o arquivo de bugs, baseado na raiz do script
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUGS_FILE="$ROOT_DIR/docs/bugs.md"

# Garante que a pasta docs existe
mkdir -p "$ROOT_DIR/docs"

# Inicia o arquivo de bugs
echo "# Documentação de Bugs Encontrados" > "$BUGS_FILE"
echo "" >> "$BUGS_FILE"

echo ""
echo "Iniciando execução da pirâmide de testes..."
echo ""

# Função para registrar bug com timestamp
registrar_bug() {
  local titulo="$1"
  local regra="$2"
  local arquivo="$3"
  local agora=$(date '+%Y-%m-%d %H:%M:%S')
  {
    echo "## $titulo em $arquivo"
    echo "- Regra violada: $regra"
    echo "- Detectado em: $agora"
    echo "- Status: Aberto"
    echo ""
  } >> "$BUGS_FILE"
}

# -------------------------------
# Procurar e rodar testes .NET
# -------------------------------
echo "Procurando projetos .NET para testar..."
find "$ROOT_DIR/ExameDesenvolvedorDeTestes" -type f \( -name "*.csproj" -o -name "*.sln" \) | while read proj; do
  echo "Executando testes em $proj"
  # Só restaura dependências se não houver pasta obj/bin
  proj_dir=$(dirname "$proj")
  if [ ! -d "$proj_dir/bin" ] || [ ! -d "$proj_dir/obj" ]; then
    echo "Restaurando dependências em $proj_dir"
    dotnet restore "$proj"
  fi
  if ! dotnet test "$proj" --verbosity normal; then
    registrar_bug "Bug Backend" "Regras de negócio (menores, categorias, exclusão em cascata)" "$proj"
  fi
done

# -------------------------------
# Procurar e rodar testes Node.js
# -------------------------------
echo ""
echo "Procurando projetos Node.js para testar..."
find "$ROOT_DIR/ExameDesenvolvedorDeTestes" -type f -name "package.json" ! -path "*/node_modules/*" | while read pkg; do
  dir=$(dirname "$pkg")
  echo "Verificando dependências em $dir"
  cd "$dir" || continue

  # Só instala dependências se node_modules não existir
  if [ ! -d "node_modules" ]; then
    echo "Instalando dependências em $dir"
    npm ci
  else
    echo "Dependências já instaladas em $dir"
  fi

  echo "Executando testes unitários (Vitest)"
  if ! npm run test:unit; then
    registrar_bug "Bug Frontend Unitários" "Validação de categorias em formulários" "$dir"
  fi

  echo "Executando testes de integração (Vitest)"
  if ! npm run test:integration; then
    registrar_bug "Bug Frontend Integração" "Fluxo de transações para menores de idade" "$dir"
  fi

  echo "Executando testes End-to-End (Playwright)"
  if ! npx playwright test; then
    registrar_bug "Bug Frontend End-to-End" "Exclusão em cascata no fluxo completo" "$dir"
  fi

  cd "$ROOT_DIR" || exit 1
done

# -------------------------------
# Finalização
# -------------------------------
echo ""
echo "Execução concluída!"
echo "--------------------------------------"
echo "Pirâmide de Testes:"
echo " - Base: Unitários (regras de negócio)"
echo " - Meio: Integração (fluxos entre módulos)"
echo " - Topo: End-to-End (experiência completa)"
echo ""
echo "Bugs documentados em $BUGS_FILE"
echo "--------------------------------------"
