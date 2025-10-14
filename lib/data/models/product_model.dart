// Este arquivo define a estrutura de dados de um Produto.
// É como o RG de cada item do nosso estoque.
class ProductModel {
  // Usamos 'final' porque, uma vez que um produto é criado,
  // suas propriedades não devem ser alteradas diretamente.
  // Para mudar a quantidade, por exemplo, usaremos métodos no controller.
  final String id; // Um identificador único para cada produto.
  final String name; // O nome do produto (ex: "Arroz Tio João").
  final double price; // O preço do produto.
  final String category; // A categoria (ex: "Alimentos", "Higiene").
  int quantity; // A quantidade atual em estoque. (Não é 'final' pois vai mudar)
  final int minimumQuantity; // A quantidade mínima para o alerta de "estoque baixo".

  // Este é o "construtor" da nossa classe.
  // Ele garante que, ao criar um novo produto, todas as informações
  // necessárias sejam fornecidas.
  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.quantity,
    required this.minimumQuantity,
  });
}