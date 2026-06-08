# Softwarepraktikum Projekt

## Entwicklung und Evaluation eines adaptiven Trainingssystems auf Basis physiologischer Sensordaten und Echtzeit-Feedback

---

## 1. Problemdarstellung

Moderne Wearables erfassen kontinuierlich physiologische Daten wie Herzfrequenz oder Herzratenvariabilität (HRV). In der Praxis werden diese Daten jedoch überwiegend zur nachträglichen Analyse oder zur einfachen Visualisierung genutzt. Echtzeit-Feedbacksysteme basieren häufig auf statischen Schwellenwerten und berücksichtigen weder individuelle Unterschiede zwischen Nutzern noch dynamische Veränderungen während des Trainings.

Insbesondere im Ausdauertraining ist jedoch eine kontinuierliche Anpassung der Belastung entscheidend, um Trainingsziele effizient zu erreichen und Über- oder Unterforderung zu vermeiden. Bestehende Systeme bieten hierfür nur begrenzte Unterstützung.

---

## 2. Ziel

Ziel dieser Arbeit ist die Entwicklung eines adaptiven Trainingssystems, das physiologische Sensordaten in Echtzeit verarbeitet und daraus individualisierte Trainingsentscheidungen ableitet.

- Erfassung und Verarbeitung von Herzfrequenz- und HRV-Daten
- Bestimmung des aktuellen Trainingszustandes des Nutzers (Belastungsniveau)
- Generierung adaptiver Feedbackstrategien zur Trainingssteuerung
- Unterstützung des Nutzers durch z.B. Audiofeedback beim Einhalten eines definierten Trainingsbereichs

Ein weiterer Fokus könnte auf der Untersuchung liegen, wie unterschiedliche Feedbackstrategien die Trainingsleistung und Nutzerwahrnehmung beeinflussen.

---

## 3. Systemarchitektur

Das System besteht aus folgenden Komponenten:

### Datenerfassung

Ein Brustgurt wie der **Polar H10** erfasst kontinuierlich Herzfrequenzdaten und überträgt diese an ein Smartphone (iPhone).

### Datenverarbeitung

Das Smartphone übernimmt die Echtzeitverarbeitung der Sensordaten. Dabei werden aus den Rohdaten HRV-basierte Features berechnet. Danach klassifiziert ein Machine-Learning-Modell oder ein regelbasierter Ansatz den aktuellen Trainingszustand des Nutzers.

### Entscheidungslogik

Basierend auf dem erkannten Zustand wird eine adaptive Trainingsentscheidung getroffen:

- **Reduktion** der Intensität bei Überbelastung
- **Steigerung** der Intensität bei Unterforderung
- **Stabilisierung** bei optimalem Trainingsbereich

### Feedback

Das System gibt dem Nutzer kontextabhängiges Feedback (z.B. Audiofeedback) über Kopfhörer. Dies sind sprachbasierte Hinweise, die sich auf die Geschwindigkeit des Nutzers und der Route beziehen.

---

## 4. Methodik

Zur Untersuchung der Wirksamkeit des Systems werden mehrere Feedbackstrategien implementiert und miteinander verglichen:

- **Statische Strategie:** Feedback basiert auf festen Schwellenwerten
- **Kontextbasierte Strategie:** Berücksichtigung kurzfristiger Veränderungen (z.B. HRV)
- **Personalisierte Strategie:** Anpassung an individuelle Nutzercharakteristika

Das System wird iterativ entwickelt und im Rahmen von Feldtests unter realen Laufbedingungen evaluiert.

---

## 5. Evaluation

Die Evaluation umfasst sowohl objektive als auch subjektive Metriken:

### Objektive Metriken

- Anteil der Trainingszeit im Zielbereich
- Abweichung von der Zielherzfrequenz
- Stabilität der Herzfrequenz während des Trainings

### Subjektive Metriken

- Wahrgenommene Belastung (Borg-Skala)
- Usability
- Wahrgenommene Nützlichkeit des Feedbacks

---

## 6. Techstack

- **Brustgurt:** Polar H10
- **Smartphone:** iPhone – Datenverarbeitung bzw. Verarbeitungseinheit
- **ML-Inferenz:** CoreML (lokal auf dem Gerät)
- **Audioausgabe:** Kopfhörer

---

## 7. Wissenschaftlicher Kontext

Die Arbeit basiert auf aktuellen Forschungsergebnissen im Bereich:

- Wearable Computing
- Physiological Computing
- Human Activity Recognition
- Adaptive Feedbacksysteme im Sport

---

## 8. Literatur

- <https://www.mdpi.com/2079-6374/16/2/97>
- <https://www.mdpi.com/2075-4663/13/2/30>
- <https://www.worldscientific.com/doi/abs/10.1142/S0218126625504705>

---

## 9. Erweiterungsmöglichkeiten

Das entwickelte System bietet vielfältige Erweiterungsmöglichkeiten, die über den initialen Funktionsumfang hinausgehen und sowohl den praktischen Nutzen als auch den wissenschaftlichen Beitrag erhöhen können.

### 9.1 Datenauswertung und Visualisierung

Neben der Echtzeitverarbeitung kann eine spätere Analyse implementiert werden:

- Speicherung von Trainingsdaten
- Visualisierung von Trainingsverläufen
- Analyse individueller Fortschritte über mehrere Trainingseinheiten
- Erkennung von Verbesserungen

Dies ermöglicht eine Kombination aus Echtzeitsteuerung und langfristiger Trainingsoptimierung.

### 9.2 Erweiterung um kontextuelle Daten

- GPS-Daten (Steigung, Strecke)
- Umgebungsbedingungen (z.B. Temperatur)
- Trainingshistorie

### 9.3 Integration adaptiver Routenempfehlungen

Aufbauend auf den physiologischen Zuständen können einfache adaptive Routenstrategien eingebaut werden:

- Vorschlag alternativer Streckenabschnitte
- Anpassung der Trainingsintensität durch gezielte Streckenwahl
- Nutzung vordefinierter Routen mit unterschiedlichem Schwierigkeitsgrad
