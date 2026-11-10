# Terraform Multi-Deployment

Du bist Teil eines Entwicklungsteams, das seine Infrastruktur als Code in diesem Repository verwaltet.
Die Terraform-Konfiguration legt fest, wie viele virtuelle Instanzen vorgesehen sind, ob sie externe IP-Adressen erhalten und in welcher Region sie liegen.

Das Team möchte seinen Release-Prozess verbessern und Änderungen automatisiert in eine Development- und danach eine Produktivumgebung deployen.
Für diese Aufgabe simuliert ein GitHub-Workflow das Deployment, indem er einen `terraform plan` mit den Eingaben der jeweiligen Umgebung ausführt.
Es werden keine Ressourcen bereitgestellt - betrachte den Terraform Output für eine kompakte Zusammenfassung der geplanten Ressourcen.

## Umgebungen

Die beiden Umgebungen sollen die folgenden Input-Variablen verwendetn, um korrekte deployed zu werden:

| Einstellung | Entwicklung | Produktion |
| --- | --- | --- |
| Projekt (`project`) | `app-dev-project` | `app-prod-project` |
| Region | `europe-north1` | `europe-central2` |
| Instanzen | 1 | 4 |
| Externe IP-Adressen | Deaktiviert | Aktiviert |

## Durchführung

1. Erstelle über den **Use this template** Button ein eigenes Repository aus diesem Template (oder [klicke hier](https://github.com/V0idC0de/terraform-multi-deploy/generate))
2. Passe Code, Workflows und Repository-Einstellungen so an, dass der gewünschte Entwicklungsablauf entsteht. Dir stehen alle Tools zur Verfügung.
3. Teste den Ablauf mit einer Änderung, beispielsweise am `name` oder `machine_type` der Instanzen.

## Ziel

Zeige dein Repository und wie die Änderung bzw. dein Prozess je einen erfolgreichen Workflow-Lauf
mit Parametern für Development- und Produktionsumgebung auslöst.

Die Terraform-Outputs am Ende des Plans (diese werden auch als Annotation im GitHub Workflow sichtbar gemacht)
zeigen die erzeugten Ressourcen und ihre Einstellungen kompakt an. Du musst die Ressourcen selbst nicht analysieren.
Ohne externe IP-Adresse ist das Feld im Output `null`; bei aktivierter externer IP-Adresse ist der Wert erst nach einem Apply bekannt und erscheint als `(known after apply)`.

Ganz konkret bedeutet das für dich: In einem Workflow Run für die Developmentumgebung werden `instances`, `location` und `project`
wie bei [Umgebungen](#umgebungen) geschildert erwartet. Genauso für die Produktionskonfiguration.
Finde einen Weg, wie die richtige Konfiguration zum richtigen Zeitpunkt verwendet wird.

> [!IMPORTANT]
> Die Workflows sollen durch die von dir gewählten Aktionen automatisch starten und nicht direkt manuell gestartet werden.
> Manuelles Auslösen eines Workflows (Trigger `workflow_dispatch` oder `repository_dispatch`) ist nicht gewünscht.

**Leitfragen:**

1. Was muss ein Developer tun, um eine Änderung zu entwickeln, in Development und anschließend in Prouktion zu bringen? Wo ist der Prozess evtl. aufwändig oder sperrig?
2. Überlege, wie dein Ablauf um einen Freigabeprozess oder eine Rolle wie einen Release Manager ergänzt werden könnte, um Change Management abzubilden.

> [!TIP]
> Diese Aufgabe hat viele mögliche Lösungen. Alle haben ihre Vor- und Nachteile, sowie Kompromisse bzgl. Security.
> Nutze dir bekannte Konzepte und/oder Ansätze aus der Vorlesung für eine Umsetzung.
> Die Lösung muss nicht perfekt sein, sollte aber praktikabel und nachvollziehbar zu erklären sein.

---

## Umsetzung

**Automatisierter Deployment-Prozess:**
- **`.github/workflows/terraform.yml`**: Zwei separate Jobs (`terraform-dev`, `terraform-prod`) für Dev/Prod-Umgebungen mit automatischem Trigger auf Push/PR
- **`.github/CODEOWNERS`**: Code Owner Review für `main` erzwungen
- **Branch Protection (manuell)**: PR + 1 Approval von Code Owner für `main` aktiviert

**Workflow-Trigger:**
- Push zu `dev` → **Dev-Job** läuft
- PR von `dev` → `main` → **Beide Jobs** laufen (Preview)
- Merge zu `main` → **Prod-Job** läuft
