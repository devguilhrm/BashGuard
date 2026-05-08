#!/bin/bash

LOG_FILE="/var/log/syslog"
OUTPUT_FILE="analysis_report.txt"

clear

echo "==============================="
echo "      BASH LOG ANALYZER        "
echo "==============================="

echo "Analisando logs..."
sleep 1

# Verifica se o arquivo existe
if [ ! -f "$LOG_FILE" ]; then
    echo "Arquivo de log não encontrado!"
    exit 1
fi

# Limpa relatório anterior
> "$OUTPUT_FILE"

echo "===== RELATÓRIO DE LOGS =====" >> "$OUTPUT_FILE"
echo "Data: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Contagem total de linhas
echo "Total de linhas do log:" >> "$OUTPUT_FILE"
wc -l "$LOG_FILE" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Tentativas de erro
echo "===== ERROS ENCONTRADOS =====" >> "$OUTPUT_FILE"
grep -i "error" "$LOG_FILE" | tail -20 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Tentativas falhas de login
echo "===== LOGIN FALHO =====" >> "$OUTPUT_FILE"
grep -i "failed" "$LOG_FILE" | tail -20 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Usuários logados
echo "===== USUÁRIOS CONECTADOS =====" >> "$OUTPUT_FILE"
who >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Uso de disco
echo "===== USO DE DISCO =====" >> "$OUTPUT_FILE"
df -h >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Uso de RAM
echo "===== USO DE RAM =====" >> "$OUTPUT_FILE"
free -h >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Últimas linhas do log
echo "===== ÚLTIMAS 20 LINHAS =====" >> "$OUTPUT_FILE"
tail -20 "$LOG_FILE" >> "$OUTPUT_FILE"

echo ""
echo "Relatório gerado com sucesso!"
echo "Arquivo: $OUTPUT_FILE"
```

---
