## Capitolo 1 – Introduzione

### 1.1 Contesto industriale e motivazioni del progetto
### 1.2 Evoluzione dell’automazione e della logistica interna
### 1.3 Il reparto di integrazione in Daikin Applied Europe
### 1.4 Obiettivi del progetto di tesi

## Capitolo 2 – Analisi del problema e requisiti di progetto

### 2.1 Descrizione del contesto produttivo
### 2.2 Criticità nella movimentazione dei carichi e obiettivi funzionali
### 2.3 Definizione delle specifiche tecniche dell’AGV
#### 2.3.1 Caratteristiche del carico e condizioni operative
#### 2.3.2 Prestazioni richieste (velocità, accelerazione, precisione)
### 2.4 Requisiti hardware e software del sistema

## Capitolo 3 – Modellazione cinematica e dimensionamento meccanico

### 3.1 Architettura del veicolo a due motoruote sterzanti
### 3.2 Analisi del moto e modellazione cinematica
#### 3.2.1 Equazioni del moto e relazioni cinematiche
#### 3.2.2 Confronto tra schemi di sterzata
### 3.3 Calcolo delle coppie motrici e dimensionamento dei motori
### 3.4 Progettazione del telaio e delle strutture portanti
### 3.5 Analisi agli elementi finiti (FEM) e verifica strutturale
### 3.6 Scelta dei componenti meccanici e di potenza

## Capitolo 4 – Architettura di controllo e comunicazione

### 4.1 Struttura generale del sistema di controllo
### 4.2 Protocolli di comunicazione industriale
#### 4.2.1 Il protocollo CANopen: struttura e gestione dei nodi
#### 4.2.2 Implementazione tramite SocketCAN su Linux
### 4.4 Sistema di controllo remoto e monitoraggio

### Capitolo 5 – Il framework ROS2 come infrastruttura di integrazione

### 5.1 Motivazioni della scelta di ROS2
### 5.2 Architettura software: nodi, topic e servizi
### 5.3 Integrazione tra ROS2 e CANopen
### 5.4 Struttura dei pacchetti sviluppati
### 5.5 Strategie di controllo e gestione del veicolo in ROS2

## Capitolo 6 – Caso di studio: AGV per Daikin Applied Europe

### 6.1 Descrizione generale del veicolo realizzato
### 6.2 Architettura hardware e software implementata
### 6.3 Flusso di comunicazione tra i moduli del sistema
### 6.4 Test e validazione delle prestazioni
### 6.5 Integrazione dell’AGV nel contesto produttivo

## Capitolo 7 – Conclusioni e sviluppi futuri

### 7.1 Riepilogo dei risultati conseguiti
### 7.2 Valutazione critica del progetto
### 7.3 Possibili sviluppi futuri e prospettive industriali (es. navigazione autonoma, sistemi di visione, sistemi di sicurezza)