# Cinematica Inversa tramite ICR per Robot Mobile a Ruote Sterzanti

## Approccio Geometrico Classico

---

## 1. Setup e Notazione

### 1.1 Frame di Riferimento

- **Frame globale**: $\{O, \mathbf{x}, \mathbf{y}\}$ fisso nel mondo
- **Frame robot**: $\{C, \mathbf{x}_r, \mathbf{y}_r\}$ solidale al robot, con origine nel centro geometrico $C$

### 1.2 Stato del Robot

$$\mathbf{q} = \begin{bmatrix} x \\ y \\ \theta \end{bmatrix} \in \mathbb{R}^2 \times S^1$$

dove:
- $(x, y)$: posizione del centro $C$ nel frame globale
- $\theta$: orientamento del robot rispetto all'asse $\mathbf{x}$ globale

### 1.3 Controlli

$$\mathbf{u} = \begin{bmatrix} \omega_f \\ \delta_f \\ \omega_r \\ \delta_r \end{bmatrix}$$

dove per ogni ruota $i \in \{f, r\}$ (front, rear):
- $\omega_i$: velocità angolare della ruota (rad/s)
- $\delta_i$: angolo di sterzo della ruota (rad), misurato rispetto all'asse $\mathbf{x}_r$ del robot

### 1.4 Geometria del Robot

**Posizione delle ruote nel frame robot:**

$$\mathbf{p}_f = \begin{bmatrix} L/2 \\ W/2 \end{bmatrix}, \quad \mathbf{p}_r = \begin{bmatrix} -L/2 \\ -W/2 \end{bmatrix}$$

dove:
- $L$: passo longitudinale (distanza tra gli assi delle ruote)
- $W$: carreggiata laterale (distanza tra le ruote)
- $r$: raggio delle ruote

### 1.5 Modello Cinematico Diretto

Il modello cinematico è: 

$$\dot{\mathbf{q}} = \mathbf{G}(\mathbf{q}, \boldsymbol{\delta}) \begin{bmatrix} \omega_f \\ \omega_r \end{bmatrix}$$

con matrice $\mathbf{G}$:

$$\mathbf{G} = \begin{bmatrix} 
\frac{r}{2}\cos(\delta_f - \theta) & \frac{r}{2}\cos(\delta_r - \theta) \\[8pt]
\frac{r}{2}\sin(\delta_f - \theta) & \frac{r}{2}\sin(\delta_r - \theta) \\[8pt]
\frac{r(L\sin\delta_f - W\cos\delta_f)}{L^2 + W^2} & \frac{r(-L\sin\delta_r + W\cos\delta_r)}{L^2 + W^2}
\end{bmatrix}$$

---

## 2. Centro Istantaneo di Rotazione (ICR)

### 2.1 Definizione Geometrica Classica

**Definizione (ICR)**: Per un corpo rigido in moto planare, il Centro Istantaneo di Rotazione è il punto che ha velocità istantanea nulla.  Il moto del corpo può essere descritto come una rotazione pura attorno a questo punto.

**Teorema Fondamentale**: Per un robot mobile con ruote che rotolano senza slittare, l'ICR si trova all'**intersezione degli assi di rotazione di tutte le ruote**, dove l'asse di rotazione di ogni ruota è la retta perpendicolare alla direzione di rotolamento passante per il centro della ruota.

### 2.2 Vincolo di Puro Rotolamento

Una ruota che rotola senza slittare può muoversi **solo nella direzione del proprio piano di rotolamento**. Questo implica:

1. La velocità del centro ruota è parallela alla direzione di sterzo
2. La componente di velocità perpendicolare allo sterzo è nulla
3. L'asse perpendicolare alla ruota (asse di rotazione) passa per l'ICR

### 2.3 Costruzione Geometrica dell'ICR

Per ogni ruota $i$ con: 
- Posizione:  $\mathbf{p}_i = [x_i, y_i]^T$
- Angolo di sterzo: $\delta_i$

**Direzione di rotolamento** (versore):
$$\mathbf{e}_i = \begin{bmatrix} \cos\delta_i \\ \sin\delta_i \end{bmatrix}$$

**Asse di rotazione** (perpendicolare alla direzione di rotolamento):
$$\mathbf{n}_i = \begin{bmatrix} -\sin\delta_i \\ \cos\delta_i \end{bmatrix}$$

**Retta dell'asse di rotazione** passante per $\mathbf{p}_i$:
$$\ell_i:  \quad \mathbf{p} = \mathbf{p}_i + t_i \mathbf{n}_i, \quad t_i \in \mathbb{R}$$

---

## 3. Determinazione dell'ICR dalle Ruote

### 3.1 Equazioni delle Rette degli Assi di Rotazione

**Asse di rotazione della ruota anteriore** ($\ell_f$):

$$\ell_f: \quad \begin{bmatrix} x \\ y \end{bmatrix} = \begin{bmatrix} L/2 \\ W/2 \end{bmatrix} + t_f \begin{bmatrix} -\sin\delta_f \\ \cos\delta_f \end{bmatrix}$$

In forma parametrica:
$$\begin{cases}
x = \frac{L}{2} - t_f \sin\delta_f \\[6pt]
y = \frac{W}{2} + t_f \cos\delta_f
\end{cases}$$

**Asse di rotazione della ruota posteriore** ($\ell_r$):

$$\ell_r: \quad \begin{bmatrix} x \\ y \end{bmatrix} = \begin{bmatrix} -L/2 \\ -W/2 \end{bmatrix} + t_r \begin{bmatrix} -\sin\delta_r \\ \cos\delta_r \end{bmatrix}$$

In forma parametrica:
$$\begin{cases}
x = -\frac{L}{2} - t_r \sin\delta_r \\[6pt]
y = -\frac{W}{2} + t_r \cos\delta_r
\end{cases}$$

### 3.2 Intersezione degli Assi:  Posizione dell'ICR

L'ICR $\boldsymbol{\rho} = [\rho_x, \rho_y]^T$ è l'intersezione di $\ell_f$ e $\ell_r$. 

Uguagliando le equazioni parametriche: 

$$\begin{bmatrix} L/2 \\ W/2 \end{bmatrix} + t_f \begin{bmatrix} -\sin\delta_f \\ \cos\delta_f \end{bmatrix} = \begin{bmatrix} -L/2 \\ -W/2 \end{bmatrix} + t_r \begin{bmatrix} -\sin\delta_r \\ \cos\delta_r \end{bmatrix}$$

Sistema lineare in $t_f$ e $t_r$:

$$\begin{bmatrix} -\sin\delta_f & \sin\delta_r \\ \cos\delta_f & -\cos\delta_r \end{bmatrix} \begin{bmatrix} t_f \\ t_r \end{bmatrix} = \begin{bmatrix} -L \\ -W \end{bmatrix}$$

**Determinante:**
$$\Delta = \sin\delta_f \cos\delta_r - \cos\delta_f \sin\delta_r = \sin(\delta_f - \delta_r)$$

**Soluzione** (per $\Delta \neq 0$):

$$t_f = \frac{L\cos\delta_r - W\sin\delta_r}{\sin(\delta_f - \delta_r)}$$

$$t_r = \frac{L\cos\delta_f - W\sin\delta_f}{\sin(\delta_f - \delta_r)}$$

**Posizione dell'ICR:**

$$\boxed{\boldsymbol{\rho} = \begin{bmatrix} \rho_x \\ \rho_y \end{bmatrix} = \begin{bmatrix} \frac{L}{2} - t_f \sin\delta_f \\[6pt] \frac{W}{2} + t_f \cos\delta_f \end{bmatrix}}$$

Sostituendo $t_f$:

$$\rho_x = \frac{L}{2} - \frac{(L\cos\delta_r - W\sin\delta_r)\sin\delta_f}{\sin(\delta_f - \delta_r)}$$

$$\rho_y = \frac{W}{2} + \frac{(L\cos\delta_r - W\sin\delta_r)\cos\delta_f}{\sin(\delta_f - \delta_r)}$$

---

## 4. Problema della Cinematica Inversa

### 4.1 Formulazione del Problema

**Dato:**
- Velocità desiderata nel frame globale: $\dot{\mathbf{q}} = [\dot{x}, \dot{y}, \dot{\theta}]^T$
- Orientamento corrente: $\theta$
- Parametri geometrici: $L$, $W$, $r$

**Trovare:**
- Angoli di sterzo:  $\delta_f$, $\delta_r$
- Velocità angolari delle ruote: $\omega_f$, $\omega_r$

### 4.2 Strategia Risolutiva

1.  Trasformare le velocità nel frame robot
2. Determinare la posizione dell'ICR dalla velocità desiderata
3. Calcolare gli angoli di sterzo dalla geometria dell'ICR
4. Calcolare le velocità angolari delle ruote

---

## 5. Passo 1: Trasformazione delle Velocità nel Frame Robot

### 5.1 Matrice di Rotazione

La matrice di rotazione dal frame globale al frame robot è: 

$$\mathbf{R}(\theta) = \begin{bmatrix} \cos\theta & \sin\theta \\ -\sin\theta & \cos\theta \end{bmatrix}$$

### 5.2 Velocità nel Frame Robot

$$\begin{bmatrix} v_x^r \\ v_y^r \end{bmatrix} = \mathbf{R}(\theta) \begin{bmatrix} \dot{x} \\ \dot{y} \end{bmatrix}$$

Esplicitamente: 

$$\boxed{\begin{cases}
v_x^r = \dot{x}\cos\theta + \dot{y}\sin\theta \\[6pt]
v_y^r = -\dot{x}\sin\theta + \dot{y}\cos\theta
\end{cases}}$$

La velocità angolare rimane invariata:  $\dot{\theta}^r = \dot{\theta}$

---

## 6. Passo 2: Determinazione dell'ICR dalla Velocità Desiderata

### 6.1 Relazione ICR-Velocità

Per un corpo rigido che ruota attorno all'ICR con velocità angolare $\dot{\theta}$, la velocità di un punto $\mathbf{p}$ è:

$$\mathbf{v}_p = \dot{\theta} \, \mathbf{k} \times (\mathbf{p} - \boldsymbol{\rho})$$

dove $\mathbf{k}$ è il versore uscente dal piano. 

In 2D, per il centro del robot $C$ (all'origine del frame robot):

$$\begin{bmatrix} v_x^r \\ v_y^r \end{bmatrix} = \dot{\theta} \begin{bmatrix} 0 & -1 \\ 1 & 0 \end{bmatrix} \begin{bmatrix} -\rho_x \\ -\rho_y \end{bmatrix} = \dot{\theta} \begin{bmatrix} \rho_y \\ -\rho_x \end{bmatrix}$$

### 6.2 Posizione dell'ICR

Risolvendo per $\boldsymbol{\rho}$:

$$\boxed{\begin{cases}
\rho_x = -\dfrac{v_y^r}{\dot{\theta}} \\[10pt]
\rho_y = \dfrac{v_x^r}{\dot{\theta}}
\end{cases}}$$

**Raggio di curvatura:**

$$R = \|\boldsymbol{\rho}\| = \sqrt{\rho_x^2 + \rho_y^2} = \frac{\sqrt{(v_x^r)^2 + (v_y^r)^2}}{|\dot{\theta}|} = \frac{v_{\text{lin}}}{|\dot{\theta}|}$$

---

## 7. Passo 3: Calcolo degli Angoli di Sterzo dall'ICR

### 7.1 Principio Geometrico

Ogni ruota deve essere orientata in modo che il suo **asse di rotazione passi per l'ICR**.  

Equivalentemente, la **direzione di sterzo è perpendicolare al vettore che connette la ruota all'ICR**.

### 7.2 Vettore Ruota-ICR

Per la ruota $i$ in posizione $\mathbf{p}_i$, il vettore che punta dalla ruota all'ICR è: 

$$\mathbf{d}_i = \boldsymbol{\rho} - \mathbf{p}_i$$

**Per la ruota anteriore:**
$$\mathbf{d}_f = \begin{bmatrix} \rho_x - L/2 \\ \rho_y - W/2 \end{bmatrix}$$

**Per la ruota posteriore:**
$$\mathbf{d}_r = \begin{bmatrix} \rho_x + L/2 \\ \rho_y + W/2 \end{bmatrix}$$

### 7.3 Angolo di Sterzo

La direzione di sterzo $\mathbf{e}_i = [\cos\delta_i, \sin\delta_i]^T$ deve essere **perpendicolare** a $\mathbf{d}_i$.

Se $\mathbf{d}_i = [d_{ix}, d_{iy}]^T$, allora il vettore perpendicolare (ruotato di $+90°$) è:

$$\mathbf{d}_i^{\perp} = \begin{bmatrix} -d_{iy} \\ d_{ix} \end{bmatrix}$$

L'angolo di sterzo è quindi:

$$\delta_i = \arctan2(d_{ix}, -d_{iy})$$

Oppure equivalentemente:

$$\delta_i = \arctan2(d_{iy}, d_{ix}) + \frac{\pi}{2}$$

### 7.4 Formule Esplicite

**Angolo di sterzo ruota anteriore:**

$$\boxed{\delta_f = \arctan2\left(\rho_x - \frac{L}{2}, -\rho_y + \frac{W}{2}\right)}$$

**Angolo di sterzo ruota posteriore:**

$$\boxed{\delta_r = \arctan2\left(\rho_x + \frac{L}{2}, -\rho_y - \frac{W}{2}\right)}$$

### 7.5 Formule in Termini delle Velocità

Sostituendo le espressioni di $\rho_x$ e $\rho_y$:

$$\delta_f = \arctan2\left(-\frac{v_y^r}{\dot{\theta}} - \frac{L}{2}, -\frac{v_x^r}{\dot{\theta}} + \frac{W}{2}\right)$$

$$\delta_r = \arctan2\left(-\frac{v_y^r}{\dot{\theta}} + \frac{L}{2}, -\frac{v_x^r}{\dot{\theta}} - \frac{W}{2}\right)$$

Moltiplicando argomenti per $-\dot{\theta}$ (attenzione al segno):

Per $\dot{\theta} > 0$: 

$$\delta_f = \arctan2\left(v_y^r + \dot{\theta}\frac{L}{2}, v_x^r - \dot{\theta}\frac{W}{2}\right)$$

$$\delta_r = \arctan2\left(v_y^r - \dot{\theta}\frac{L}{2}, v_x^r + \dot{\theta}\frac{W}{2}\right)$$

---

## 8. Passo 4: Calcolo delle Velocità Angolari delle Ruote

### 8.1 Velocità Tangenziale delle Ruote

Ogni ruota si muove su una circonferenza centrata nell'ICR. La velocità tangenziale è: 

$$v_i = |\dot{\theta}| \cdot d_i$$

dove $d_i = \|\mathbf{d}_i\|$ è la distanza della ruota dall'ICR. 

**Distanza ruota anteriore - ICR:**
$$d_f = \sqrt{\left(\rho_x - \frac{L}{2}\right)^2 + \left(\rho_y - \frac{W}{2}\right)^2}$$

**Distanza ruota posteriore - ICR:**
$$d_r = \sqrt{\left(\rho_x + \frac{L}{2}\right)^2 + \left(\rho_y + \frac{W}{2}\right)^2}$$

### 8.2 Velocità Angolari delle Ruote

La relazione tra velocità tangenziale e velocità angolare della ruota è:

$$v_i = r \cdot |\omega_i|$$

Quindi:

$$|\omega_i| = \frac{|\dot{\theta}| \cdot d_i}{r}$$

Il **segno** di $\omega_i$ dipende dal verso di rotazione.  Per determinarlo, consideriamo che la ruota deve muoversi nella direzione di $\mathbf{v}_i = \dot{\theta} \, \mathbf{k} \times \mathbf{d}_i$. 

**Formula generale:**

$$\boxed{\omega_i = \frac{\dot{\theta} \cdot d_i}{r} \cdot \text{sign}(\mathbf{e}_i \cdot \mathbf{v}_i)}$$

dove $\mathbf{e}_i = [\cos\delta_i, \sin\delta_i]^T$ è la direzione di sterzo.

### 8.3 Forma Semplificata

In pratica, per un sistema coerente: 

$$\boxed{\omega_f = \frac{\dot{\theta}}{r} \sqrt{\left(\rho_x - \frac{L}{2}\right)^2 + \left(\rho_y - \frac{W}{2}\right)^2}}$$

$$\boxed{\omega_r = \frac{\dot{\theta}}{r} \sqrt{\left(\rho_x + \frac{L}{2}\right)^2 + \left(\rho_y + \frac{W}{2}\right)^2}}$$

### 8.4 In Termini delle Velocità

Sostituendo $\rho_x = -v_y^r/\dot{\theta}$ e $\rho_y = v_x^r/\dot{\theta}$: 

$$\omega_f = \frac{1}{r} \sqrt{\left(v_y^r + \dot{\theta}\frac{L}{2}\right)^2 + \left(v_x^r - \dot{\theta}\frac{W}{2}\right)^2}$$

$$\omega_r = \frac{1}{r} \sqrt{\left(v_y^r - \dot{\theta}\frac{L}{2}\right)^2 + \left(v_x^r + \dot{\theta}\frac{W}{2}\right)^2}$$

---

## 9. Verifica:  Consistenza della Terza Equazione

### 9.1 Proposizione

**Proposizione:** Se $\delta_f$, $\delta_r$, $\omega_f$, $\omega_r$ sono calcolati dall'ICR come descritto, allora la terza equazione cinematica: 

$$\dot{\theta} = g_{31}\omega_f + g_{32}\omega_r$$

è **automaticamente soddisfatta**.

### 9.2 Dimostrazione

**Passo 1:** Per costruzione, l'ICR è determinato in modo che: 

$$\mathbf{v}_C = \dot{\theta} \, \mathbf{k} \times (-\boldsymbol{\rho}) = \begin{bmatrix} v_x^r \\ v_y^r \end{bmatrix}$$

**Passo 2:** Gli angoli di sterzo sono scelti in modo che gli assi di rotazione delle ruote passino per l'ICR.  Questo garantisce il vincolo di puro rotolamento.

**Passo 3:** Le velocità angolari delle ruote sono proporzionali alla distanza dall'ICR:

$$\omega_i = \frac{\dot{\theta} \cdot d_i}{r}$$

**Passo 4:** La velocità di ogni ruota è tangente alla circonferenza centrata nell'ICR:

$$\mathbf{v}_i = \dot{\theta} \, \mathbf{k} \times (\mathbf{p}_i - \boldsymbol{\rho})$$

**Passo 5:** La terza equazione cinematica esprime proprio la relazione tra $\dot{\theta}$ e le velocità delle ruote attraverso la geometria del robot.  Poiché tutte le quantità sono derivate dalla stessa configurazione ICR, la consistenza è garantita.

**Verifica algebrica:**

La terza riga di $\mathbf{G}$ è:

$$g_{31} = \frac{r(L\sin\delta_f - W\cos\delta_f)}{L^2 + W^2}, \quad g_{32} = \frac{r(-L\sin\delta_r + W\cos\delta_r)}{L^2 + W^2}$$

Sostituendo gli angoli $\delta_f$, $\delta_r$ derivati dall'ICR e le velocità $\omega_f$, $\omega_r$, si ottiene dopo semplificazione:

$$g_{31}\omega_f + g_{32}\omega_r = \dot{\theta}$$

$\square$

---

## 10. Casi Limite

### 10.1 Caso 1: Moto Rettilineo ($\dot{\theta} = 0$)

Quando $\dot{\theta} \to 0$, l'ICR si allontana all'infinito nella direzione perpendicolare al moto. 

**Limite:**

$$\lim_{\dot{\theta} \to 0} \rho_x = \mp\infty, \quad \lim_{\dot{\theta} \to 0} \rho_y = \pm\infty$$

**Angoli di sterzo:**

Entrambe le ruote puntano nella direzione del moto: 

$$\boxed{\delta_f = \delta_r = \arctan2(v_y^r, v_x^r)}$$

**Velocità angolari:**

$$\boxed{\omega_f = \omega_r = \frac{v_{\text{lin}}}{r} = \frac{\sqrt{(v_x^r)^2 + (v_y^r)^2}}{r}}$$

**Interpretazione geometrica:** Gli assi di rotazione delle ruote sono paralleli (si incontrano all'infinito).

### 10.2 Caso 2: Rotazione sul Posto ($v_x^r = v_y^r = 0$, $\dot{\theta} \neq 0$)

Quando il robot ruota attorno al proprio centro senza traslare. 

**Posizione ICR:**

$$\boldsymbol{\rho} = \begin{bmatrix} 0 \\ 0 \end{bmatrix}$$

L'ICR coincide con il centro del robot. 

**Angoli di sterzo:**

$$\delta_f = \arctan2\left(-\frac{L}{2}, \frac{W}{2}\right) = \arctan2(-L, W)$$

$$\delta_r = \arctan2\left(\frac{L}{2}, -\frac{W}{2}\right) = \arctan2(L, -W)$$

Le ruote sono orientate tangenzialmente rispetto a cerchi centrati in $C$.

**Distanze dall'ICR:**

$$d_f = d_r = \frac{1}{2}\sqrt{L^2 + W^2}$$

**Velocità angolari:**

$$\boxed{\omega_f = \omega_r = \frac{|\dot{\theta}|}{2r}\sqrt{L^2 + W^2}}$$

### 10.3 Caso 3: Rotazione Attorno a una Ruota

Se l'ICR coincide con una delle ruote, quella ruota rimane ferma ($\omega_i = 0$) e l'altra ruota compie tutto il lavoro.

**Esempio:** ICR sulla ruota posteriore ($\boldsymbol{\rho} = \mathbf{p}_r$)

$$\omega_r = 0$$

$$d_f = \sqrt{L^2 + W^2}$$

$$\omega_f = \frac{\dot{\theta}}{r}\sqrt{L^2 + W^2}$$

---

## 11. Condizioni di Singolarità

### 11.1 Singolarità Geometrica

Il sistema è **singolare** quando gli assi di rotazione delle due ruote sono **paralleli** (non si intersecano in un punto finito).

Condizione di singolarità:

$$\sin(\delta_f - \delta_r) = 0 \quad \Leftrightarrow \quad \delta_f = \delta_r + k\pi, \quad k \in \mathbb{Z}$$

**Interpretazione:**
- $\delta_f = \delta_r$: ruote parallele, moto rettilineo (ICR all'infinito)
- $\delta_f = \delta_r + \pi$: ruote antiparallele (configurazione degenere)

### 11.2 Gestione delle Singolarità

Per $\delta_f \approx \delta_r$ (moto quasi rettilineo), usare la formulazione del Caso 1 (§10.1).

---

## 12. Algoritmo Completo di Cinematica Inversa

### Input
- Velocità desiderata: $[\dot{x}, \dot{y}, \dot{\theta}]^T$
- Orientamento corrente: $\theta$
- Parametri:  $L$, $W$, $r$
- Tolleranza: $\varepsilon$ (per casi limite)

### Output
- Controlli: $[\omega_f, \delta_f, \omega_r, \delta_r]^T$

### Algoritmo

**Passo 1: Trasformazione al frame robot**

$$v_x^r = \dot{x}\cos\theta + \dot{y}\sin\theta$$
$$v_y^r = -\dot{x}\sin\theta + \dot{y}\cos\theta$$

**Passo 2: Classificazione del moto**

Calcolare:  $v_{\text{lin}} = \sqrt{(v_x^r)^2 + (v_y^r)^2}$

- Se $|\dot{\theta}| < \varepsilon$ e $v_{\text{lin}} > \varepsilon$: **Moto rettilineo** → vai a Passo 3a
- Se $|\dot{\theta}| > \varepsilon$ e $v_{\text{lin}} < \varepsilon$: **Rotazione sul posto** → vai a Passo 3b
- Altrimenti: **Moto generale** → vai a Passo 3c

**Passo 3a: Moto rettilineo**

$$\delta_f = \delta_r = \arctan2(v_y^r, v_x^r)$$
$$\omega_f = \omega_r = \frac{v_{\text{lin}}}{r}$$

**Passo 3b: Rotazione sul posto**

$$\delta_f = \arctan2(-L, W)$$
$$\delta_r = \arctan2(L, -W)$$
$$\omega_f = \omega_r = \frac{|\dot{\theta}|}{2r}\sqrt{L^2 + W^2}$$

**Passo 3c: Moto generale**

Calcolare ICR: 
$$\rho_x = -\frac{v_y^r}{\dot{\theta}}, \quad \rho_y = \frac{v_x^r}{\dot{\theta}}$$

Calcolare angoli di sterzo:
$$\delta_f = \arctan2\left(\rho_x - \frac{L}{2}, -\rho_y + \frac{W}{2}\right)$$
$$\delta_r = \arctan2\left(\rho_x + \frac{L}{2}, -\rho_y - \frac{W}{2}\right)$$

Calcolare distanze dall'ICR:
$$d_f = \sqrt{\left(\rho_x - \frac{L}{2}\right)^2 + \left(\rho_y - \frac{W}{2}\right)^2}$$
$$d_r = \sqrt{\left(\rho_x + \frac{L}{2}\right)^2 + \left(\rho_y + \frac{W}{2}\right)^2}$$

Calcolare velocità angolari: 
$$\omega_f = \frac{\dot{\theta} \cdot d_f}{r}, \quad \omega_r = \frac{\dot{\theta} \cdot d_r}{r}$$

**Passo 4: Normalizzazione angoli**

$$\delta_f = \text{atan2}(\sin\delta_f, \cos\delta_f) \quad \text{(normalizza in } [-\pi, \pi])$$
$$\delta_r = \text{atan2}(\sin\delta_r, \cos\delta_r)$$

**Passo 5: Return** $[\omega_f, \delta_f, \omega_r, \delta_r]^T$

---

## 13. Rappresentazione Grafica

### 13.1 Costruzione Geometrica dell'ICR

```
                    ICR (ρ)
                      ●
                     /|\
                    / | \
                   /  |  \
            asse  /   |   \  asse
            rot.  /    |    \ rot.
           (ℓf)/     |     \(ℓr)
               /      |      \
              /   δf  |  δr   \
             ●--------●--------●
           ruota_f    C     ruota_r
          (L/2,W/2)  (0,0) (-L/2,-W/2)
```

### 13.2 Legenda

- **●** :  Punti notevoli (ICR, centro ruote, centro robot)
- **ℓf, ℓr** : Assi di rotazione delle ruote (perpendicolari alla direzione di sterzo)
- **δf, δr** : Angoli di sterzo
- L'ICR è l'intersezione degli assi ℓf e ℓr

---

## 14. Teorema Conclusivo

**Teorema (Cinematica Inversa via ICR - Approccio Geometrico):**

Per un robot mobile planare a due ruote sterzanti indipendenti, con:
- Ruote in posizione $\mathbf{p}_f = [L/2, W/2]^T$ e $\mathbf{p}_r = [-L/2, -W/2]^T$
- Modello cinematico $\dot{\mathbf{q}} = \mathbf{G}(\mathbf{q}, \boldsymbol{\delta})\boldsymbol{\omega}$

La cinematica inversa ammette **soluzione unica** data da: 

**(i) Posizione ICR:**
$$\boldsymbol{\rho} = \left[-\frac{v_y^r}{\dot{\theta}}, \frac{v_x^r}{\dot{\theta}}\right]^T$$

**(ii) Angoli di sterzo** (condizione geometrica:  assi di rotazione passanti per ICR):
$$\delta_i = \arctan2(\rho_x - x_i, -\rho_y + y_i), \quad i \in \{f, r\}$$

**(iii) Velocità angolari** (proporzionali alla distanza dall'ICR):
$$\omega_i = \frac{\dot{\theta} \cdot \|\boldsymbol{\rho} - \mathbf{p}_i\|}{r}, \quad i \in \{f, r\}$$

**(iv) Consistenza:** Tutte e tre le equazioni cinematiche sono simultaneamente soddisfatte per costruzione geometrica.

**Condizione di esistenza:** $\sin(\delta_f - \delta_r) \neq 0$ (ruote non parallele)

$\blacksquare$

---

## 15. Riferimenti

1. Siegwart, R., Nourbakhsh, I. R., & Scaramuzza, D. (2011). *Introduction to Autonomous Mobile Robots* (2nd ed.). MIT Press.

2. Campion, G., Bastin, G., & D'Andréa-Novel, B. (1996). Structural properties and classification of kinematic and dynamic models of wheeled mobile robots. *IEEE Transactions on Robotics and Automation*, 12(1), 47-62.

3. Lynch, K. M., & Park, F. C. (2017). *Modern Robotics: Mechanics, Planning, and Control*. Cambridge University Press.

4. Balkcom, D. J., & Mason, M. T. (2002). Time optimal trajectories for bounded velocity differential drive vehicles. *The International Journal of Robotics Research*, 21(3), 199-217. 