# Lista de Tarefas (Todo List)

Uma aplicação Flutter completa para gerenciamento de tarefas com persistência local.

## Funcionalidades

### ✅ Funcionalidades Básicas
- **Adicionar nova tarefa**: Crie tarefas com título e descrição
- **Marcar como concluída**: Toque no checkbox para alternar o status
- **Editar tarefa existente**: Edite título e descrição de tarefas
- **Excluir tarefa**: Remova tarefas com confirmação
- **Filtrar por status**: Visualize todas, pendentes ou concluídas

### 🚀 Funcionalidades Avançadas
- **Persistência local**: Dados salvos automaticamente com SharedPreferences
- **Estatísticas**: Visualize contadores de tarefas por status
- **Interface moderna**: Design Material Design com cores e ícones
- **Busca e ordenação**: Funcionalidades extras para melhor organização
- **Limpeza automática**: Remova tarefas concluídas em lote

## Estrutura do Projeto

### Classes Principais

#### `Tarefa`
```dart
class Tarefa {
  int id;                    // ID único da tarefa
  String titulo;             // Título da tarefa
  String descricao;          // Descrição detalhada
  bool concluida;            // Status de conclusão
  DateTime dataCriacao;      // Data e hora de criação
}
```

#### `GerenciadorTarefas`
```dart
class GerenciadorTarefas {
  // Métodos principais
  void adicionarTarefa(Tarefa tarefa);
  void removerTarefa(int id);
  void marcarConcluida(int id);
  List<Tarefa> obterTarefasPorStatus(bool concluida);
  
  // Métodos adicionais
  void editarTarefa(int id, {String? novoTitulo, String? novaDescricao});
  void alternarStatus(int id);
  List<Tarefa> obterTodasTarefas();
  Map<String, int> obterEstatisticas();
}
```

## Como Executar

1. **Instalar dependências**:
   ```bash
   flutter pub get
   ```

2. **Executar a aplicação**:
   ```bash
   flutter run
   ```

## Funcionalidades Detalhadas

### 📝 Gerenciamento de Tarefas
- **Adicionar**: Toque no botão "+" para criar nova tarefa
- **Editar**: Use o menu de opções (⋮) para editar
- **Excluir**: Confirmação antes da exclusão
- **Marcar**: Toque no checkbox para alternar status

### 🔍 Filtros
- **Todas**: Mostra todas as tarefas
- **Pendentes**: Apenas tarefas não concluídas
- **Concluídas**: Apenas tarefas finalizadas

### 📊 Estatísticas
- **Total**: Número total de tarefas
- **Pendentes**: Tarefas não concluídas
- **Concluídas**: Tarefas finalizadas

### 💾 Persistência
- Dados salvos automaticamente no dispositivo
- Carregamento automático ao iniciar o app
- Sincronização em tempo real

## Tecnologias Utilizadas

- **Flutter**: Framework de desenvolvimento
- **Dart**: Linguagem de programação
- **SharedPreferences**: Persistência local
- **Material Design**: Interface do usuário

## Estrutura de Arquivos

```
lib/
├── main.dart              # Aplicação principal
├── tarefa.dart            # Classe Tarefa
└── gerenciador_tarefas.dart # Classe GerenciadorTarefas
```

## Melhorias Futuras

- [ ] Sincronização com nuvem
- [ ] Categorias de tarefas
- [ ] Lembretes e notificações
- [ ] Temas personalizáveis
- [ ] Exportação de dados
- [ ] Modo offline avançado

## Contribuição

Este projeto foi desenvolvido como exercício de aprendizado em Flutter/Dart, demonstrando:
- Programação orientada a objetos
- Gerenciamento de estado
- Persistência de dados
- Interface de usuário responsiva
- Boas práticas de desenvolvimento

