# QA Project - Testes de Qualidade

## Como rodar os testes
- **Back-end Unitários:** `dotnet test backend-tests/Unit`
- **Back-end Integração:** `dotnet test backend-tests/Integration`
- **Back-end E2E:** `dotnet test backend-tests/E2E`
- **Front-end Unitários:** `npm run test:unit`
- **Front-end Integração:** `npm run test:integration`
- **Front-end E2E:** `npx playwright test`

## Pirâmide de Testes
- Base: Unitários (regras de negócio)
- Meio: Integração (fluxos entre módulos)
- Topo: End-to-End (experiência completa)

## Bugs encontrados
Documentados em `docs/bugs.md`.

## Justificativa
- Foco em regras de negócio críticas.
- CI com GitHub Actions garante execução contínua.

Dê permissão de execução:

bash
chmod +x qa-run.sh
No VS Code, abra o terminal e rode:

bash
./qa-run.sh