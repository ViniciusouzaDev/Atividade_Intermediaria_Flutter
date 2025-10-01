class Tarefa {
  int id;
  String titulo;
  String descricao;
  bool concluida;
  DateTime dataCriacao;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    this.concluida = false,
    DateTime? dataCriacao,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  // Construtor nomeado para criar tarefa com ID automático
  Tarefa.nova({
    required this.titulo,
    required this.descricao,
    this.concluida = false,
    DateTime? dataCriacao,
  }) : id = DateTime.now().millisecondsSinceEpoch,
       dataCriacao = dataCriacao ?? DateTime.now();

  // Método para marcar como concluída
  void marcarConcluida() {
    concluida = true;
  }

  // Método para marcar como pendente
  void marcarPendente() {
    concluida = false;
  }

  // Método para alternar status
  void alternarStatus() {
    concluida = !concluida;
  }

  // Método para editar tarefa
  void editar({String? novoTitulo, String? novaDescricao}) {
    if (novoTitulo != null) titulo = novoTitulo;
    if (novaDescricao != null) descricao = novaDescricao;
  }

  // Método para converter para Map (útil para persistência)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'concluida': concluida,
      'dataCriacao': dataCriacao.toIso8601String(),
    };
  }

  // Construtor para criar a partir de Map
  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      concluida: map['concluida'],
      dataCriacao: DateTime.parse(map['dataCriacao']),
    );
  }

  // Método toString para exibição
  @override
  String toString() {
    return 'Tarefa{id: $id, titulo: $titulo, concluida: $concluida}';
  }

  // Método para verificar se duas tarefas são iguais
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tarefa && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

