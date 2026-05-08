
# Bash Log Analyzer

## `log_analyzer.sh`

---

# O que esse projeto ensina

* Manipulação de logs
* Automação Linux
* `grep`
* `tail`
* `wc`
* `if`
* Variáveis Bash
* Relatórios automáticos
* Administração Linux
* Fundamentos de cybersecurity

---

# Ideias para melhorar

## Adicionar cores ANSI

```bash
echo -e "\e[31mERRO DETECTADO\e[0m"
```

---

## Detectar ataques SSH

Pesquisar:

```bash
grep "Failed password"
```

---

## Gerar logs em pasta própria

```bash
logs/report_$(date +%F).txt
```

---

## Mostrar top processos

```bash
ps aux --sort=-%mem | head
```


---

