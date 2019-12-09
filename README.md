## Cerberus Lang

--------------------------

### Linguagem

**Tipos de variáveis**

```
u8:  inteiro, sem sinal, de 8 bits

u16: inteiro, sem sinal, de 16 bits

u32: inteiro, sem sinal, de 32 bits

i8:  inteiro, com sinal, de 8 bits

i16: inteiro, com sinal, de 16 bits

i32: inteiro, com sinal, de 32 bits

int: sinônimo de i32

double: número real com ponto flutuante

string: cadeia de caracteres
```

**Declaração de variável**

```
let x: u8 = 5     (constante)

let mut x: u8 = 5 (variável, pode ser redefinida)
```

**Redefinição de variáveis mutáveis**

```
x = 6
```

**Declaração de função**

```
func helloWorld(n: u32): u32 { ... }
```

**Execução de função**

```
helloWorld(3)
```

**Estruturas condicionais**

```
if (x > 5)   { ... }

elif (x > 3) { ... }

else         { ... }

while(x > 5) { ... }
```

---------------------------

### Execução:

Tendo o _Ruby_ instalado, entre na pasta _Ruby_, e execute o comando

```
ruby main.rb << caminho do arquivo >>
```

Exemplo:

```
ruby main.rb ../cerberus_scripts/funcoes.crb
```

--------------------------