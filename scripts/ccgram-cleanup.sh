#!/usr/bin/env bash
# CCGram pre-start cleanup:
#   1) kill the ccgram tmux session (and whatever runs inside it)
#   2) kill leftover agent processes (claude, codex, kimi, pi)
#   3) wipe ~/.ccgram state files, keeping only .env
set -u

CCGRAM_DIR="/home/eduardo/.ccgram"

echo "[cleanup] iniciando pre-start cleanup do ccgram ($(date -Is))"

# 1) sessão tmux do ccgram
if command -v tmux >/dev/null 2>&1; then
  if tmux kill-session -t ccgram 2>/dev/null; then
    echo "[cleanup] sessão tmux 'ccgram' encerrada"
  else
    echo "[cleanup] nenhuma sessão tmux 'ccgram' ativa"
  fi
fi

# 2) processos de agentes órfãos (claude, codex, kimi, pi)
for agent in claude codex kimi pi; do
  if pkill -x "$agent" 2>/dev/null; then
    echo "[cleanup] processos '$agent' encerrados"
  else
    echo "[cleanup] nenhum processo '$agent' rodando"
  fi
done

# 3) limpa ~/.ccgram mantendo apenas o .env
if [ -d "$CCGRAM_DIR" ]; then
  find "$CCGRAM_DIR" -mindepth 1 -maxdepth 1 ! -name '.env' -exec rm -rf {} + 2>/dev/null
  echo "[cleanup] arquivos de estado removidos de $CCGRAM_DIR (mantido apenas .env)"
else
  echo "[cleanup] diretório $CCGRAM_DIR não existe; nada a limpar"
fi

echo "[cleanup] concluído"
