# Changelog

## [0.5.0] — 2026-07-06

- Repo movido para `Documentos/Skills/Cerbero` (antes `Documentos/Projetos/Cerbero`).
- Pasta de relatórios passou de `~/Documents/Cerbero/reports/` (fora do repo, caminho que na prática batia na pasta `Documents` errada em máquinas com OneDrive redirecionando `Documentos`) para `reports_cerbero/` **dentro do próprio repo**. Atualizado em `SKILL.md`, `install.ps1`, `install.sh` e `README.md`.
- `reports_cerbero/` agora é versionada como pasta (via `.gitkeep`), mas o conteúdo dos relatórios continua ignorado pelo git — cada usuário mantém os seus.

## [0.4.0] — 2026-06-29

- Nome da skill padronizado em lowercase pra bater com as outras skills da operação (sentinela, copychief): campo `name:` do frontmatter `Cerbero` → `cerbero`, slash command `/Cerbero` → `/cerbero`, e pasta de instalação `~/.claude/skills/Cerbero` → `~/.claude/skills/cerbero` (frontmatter, install scripts, README, paths internos da SKILL.md).
- **Mantidos capitalizados de propósito** (mesmo padrão de sentinela/copychief): o heading `# Cerbero —`, o nome próprio "Cerbero" no corpo do texto, a pasta de relatórios `~/Documents/Cerbero/reports/` (pasta de dados, não o nome da skill) e o nome do repo no GitHub (`bbismaq/Cerbero`).
- Já tinha sido tentado na 0.2.1 e revertido na 0.2.2 (mesmo dia, sem motivo técnico documentado — causa provável: sync de sessão paralela com cache velho sobrescreveu a mudança). Desta vez commitado de uma vez nos dois lados (working + deployed) pra fixar.

## [0.3.0] — 2026-06-04

- **Funil 8.1: downsells catalogados** (antes constavam como "ainda não catalogados"):
  - Downsell 1 do Upsell 1 (por front): A: 1+1 FREE · $49/frasco pago · total $49 · B: 3+1 FREE · $49/frasco pago · total $147 · C: 6 bottles · $29/un · total $174. Convenção "$/frasco pago" vale só pra esta etapa (FREE é pote gratuito de verdade).
  - Downsell 2 do Upsell 1 (por front): A: 1 bottle · $59 · B: 2 bottles · $49/un ($98) · C: 3 bottles · $39/un ($117).
  - Downsell 1 do Upsell 2 (universal): 3 bottles · $39/un ($117).
- Notas de proteção do 8.1: D1-B total $147 = Upsell 1-B 6 bottles é intencional (não flagar check #6); downsells do 8.1 são copy estática, sem vídeo (não flagar); estrutura completa esperada pro check #17.
- Nomenclatura: planilha da base chama o funil de "Funil 8.0 - MEMÓRIA" e o admin pode rotular "FUNIL 8.0" — não flagar quando os preços baterem com o 8.1.
- Check #11 (headline "U$X Discount"/"SAVE %") rebaixado pra validação interna: quando o preço cobrado bate com o catálogo, divergência de headline não entra no relatório. Notas "(preço ok; ...)" em linha de etapa ficaram proibidas.
- Check #16 atualizado: catálogo agora cobre Funil 8.0 e Funil 8.1.

## [0.2.2] — 2026-05-19

- Nome da skill voltou pra `Cerbero` (com C maiúsculo) em frontmatter, headings, slash command, paths e install scripts. Reverte a padronização lowercase da 0.2.1.

## [0.2.1] — 2026-05-19

- Nome da skill padronizado em lowercase: `Cerbero` → `cerbero` (frontmatter, headings, slash command, paths e install scripts).

## [0.2.0] — 2026-05-19

- Renomeado de `Checagem-de-oferta` para `Cerbero`.
- Pasta de relatórios passou de `~/Documents/Check-Offer/reports/` para `~/Documents/Cerbero/reports/`.

## [0.1.0] — 2026-05-15

Versão inicial.

### Funcionalidades

- Audita VSL/LP com checkouts no Pagamerican via `?pag_test_4=true` (sem precisar assistir o vídeo nem comprar).
- Extrai preço, preço por bottle, "De", "You save" e % off de todas as 18 ofertas típicas (3 LP + 15 funil).
- Mapeia estrutura completa do funil: entrada → upsell 1 (3 variantes) → downsell 1 → downsell 2, em cada um dos funis ligados aos botões da LP.
- Identifica as duas fontes de preço corretas:
  - LP: payload Next.js do Pagamerican (`originalUnitPrice`, `unitPrice`, `priceDiscountPercentage`).
  - Funil: HTML hardcoded da página do funil (`line-through`, `NORMALLY/TODAY`, `discount-highlight`).
- 13 checks automáticos em toda execução (sem omissão), incluindo:
  - Per-bottle exibido vs. calculado
  - Headline `U$X Discount` vs. desconto real
  - Outliers de per-bottle (menor e maior do funil)
  - Upsell var.3 == entrada do funil
  - Mesmo total entre ofertas
  - D2 mais caro que D1
  - Nomes de nós clonados sem renomear
  - Elementos ativos do checkout (timer, exit popup, live buyers)
- Gera relatório `.md` em `~/Documents/Cerbero/reports/<slug>-<data>.md` ao final de toda execução.
- Tabelas com no máximo 6 colunas + alinhamento Markdown apropriado pra render limpo em qualquer viewer.

### Limitações

- Apenas Pagamerican (outros gateways planejados).
- Não simula clique em "Iniciar simulação de compra" — confiável pra preços, não valida fluxo end-to-end.
