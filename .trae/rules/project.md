# Prompt Completo para Sistema de Marketing Multinível (MMN)

## Visão Geral do Projeto

Desenvolver uma aplicação web Flutter que simule um sistema de Marketing Multinível (MMN) completo, seguindo rigorosamente os princípios de Clean Architecture, SOLID e as convenções Dart/Flutter estabelecidas.

---

## Requisitos Funcionais

### 1. Sistema de Usuários e Autenticação

**RF001 - Cadastro de Usuários**
- Permitir cadastro com: nome completo, email, senha, telefone
- Gerar código de indicação único por usuário (ex: `CENT2024ABC`)
- Validar email único no sistema
- Criptografar senhas antes de armazenar
- Associar indicado ao indicador via cupom/código no momento do cadastro

**RF002 - Autenticação**
- Login com email e senha
- Logout com limpeza de sessão
- Recuperação de senha por email (mockado)
- Manter sessão autenticada com tokens JWT (simulados)

**RF003 - Perfil do Usuário**
- Visualizar dados pessoais
- Editar informações (exceto email)
- Visualizar código de indicação próprio
- Copiar código para compartilhamento

---

### 2. Sistema de Indicações (Rede Multinível)

**RF004 - Estrutura de Rede**
- Visualizar árvore de indicações (até 3 níveis de profundidade)
- Exibir quantidade de indicados diretos e indiretos
- Mostrar status de cada indicado (ativo/inativo)
- Calcular total de pessoas na rede

**RF005 - Pontuação por Indicação**
- Indicador ganha 100 pontos ao cadastrar novo usuário com seu código
- Indicado ganha 50 pontos de bônus ao se cadastrar
- Pontos são acumulativos e permanentes
- Histórico de ganho de pontos com data/hora/origem

---

### 3. Sistema de Compras e Comissões

**RF006 - Catálogo de Produtos**
- Listar produtos fictícios com: nome, descrição, preço, imagem
- Categorizar produtos (Eletrônicos, Cursos, Serviços, etc.)
- Busca e filtros por categoria/preço
- Detalhamento de produto individual

**RF007 - Carrinho e Checkout**
- Adicionar/remover produtos do carrinho
- Visualizar subtotal e total
- Aplicar cupom de desconto (5% de bônus para indicados)
- Simular pagamento (Pix, Cartão, Boleto - sem integração real)
- Gerar pedido após confirmação

**RF008 - Sistema de Comissões Multinível**
```
Regras de Comissão:
- Nível 1 (indicado direto compra): 10% do valor da compra
- Nível 2 (indicado do indicado): 5% do valor
- Nível 3 (terceiro nível): 2% do valor
- Indicado recebe cashback de 3% em suas próprias compras
```

**RF009 - Carteira Virtual**
- Visualizar saldo disponível (soma de comissões e pontos convertidos)
- Histórico de transações: ganhos, saques, conversões
- Conversão de pontos em saldo: 100 pontos = R$ 10,00
- Simulação de saque (mínimo R$ 50,00)

---

### 4. Dashboards e Relatórios

**RF010 - Dashboard do Usuário**
- Total de indicados (diretos + rede completa)
- Pontos acumulados
- Saldo em carteira
- Comissões do mês atual
- Ranking na plataforma (top 10)
- Gráfico de evolução mensal (compras e comissões)

**RF011 - Histórico de Atividades**
- Histórico de indicações (quem, quando)
- Histórico de compras próprias
- Histórico de comissões recebidas
- Filtros por período (últimos 7 dias, 30 dias, 6 meses)

---

### 5. Sistema de Notificações

**RF012 - Notificações em Tempo Real (simuladas)**
- Notificar quando alguém da rede faz compra
- Notificar quando recebe comissão
- Notificar quando ganha novos pontos
- Badge com contador de notificações não lidas

---

## Requisitos Não Funcionais

### RNF001 - Performance
- Carregamento inicial < 3 segundos
- Transições entre telas < 300ms
- Lazy loading em listas com +20 itens
- Cache de imagens de produtos

### RNF002 - Responsividade
- Adaptar layout para mobile (< 600px), tablet (600-1200px) e desktop (> 1200px)
- Navigation adaptativa (drawer no mobile, sidebar no desktop)
- Grids responsivos (1 coluna mobile, 2-3 desktop)

### RNF003 - Segurança
- Nunca expor senhas em logs
- Validação de inputs em todos os formulários
- Proteção de rotas (usuários não autenticados redirecionados para login)
- Sanitização de dados antes de persistência

### RNF004 - Usabilidade
- Feedback visual em todas as ações (loading, success, error)
- Mensagens de erro claras e acionáveis
- Confirmação em ações destrutivas (ex: remover do carrinho)
- Tooltips em ícones e ações não óbvias

### RNF005 - Acessibilidade
- Contraste mínimo WCAG AA
- Alvos de toque ≥ 48x48 dp
- Labels semânticos em formulários
- Navegação por teclado funcional

---

## Arquitetura Técnica

### Estrutura de Pastas
```
lib/
├── main.dart
├── globals/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── commission_rates.dart
│   │   └── routes.dart
│   ├── themes/
│   │   └── app_theme.dart
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── loading_indicator.dart
│   │   ├── error_widget.dart
│   │   └── network_image_cached.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   ├── date_utils.dart
│   │   └── currency_formatter.dart
│   └── services/
│       ├── navigation_service.dart
│       └── notification_service.dart
├── modules/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── auth_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── auth_controller.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── register_page.dart
│   │       │   └── forgot_password_page.dart
│   │       └── widgets/
│   │           └── auth_form.dart
│   ├── network/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── network_node_model.dart
│   │   │   └── repositories/
│   │   │       └── network_repository_impl.dart
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── network_controller.dart
│   │       ├── pages/
│   │       │   └── network_tree_page.dart
│   │       └── widgets/
│   │           ├── network_tree_widget.dart
│   │           └── network_card.dart
│   ├── products/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── product_model.dart
│   │   │   │   └── cart_item_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── products_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── products_repository_impl.dart
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   ├── products_controller.dart
│   │       │   └── cart_controller.dart
│   │       ├── pages/
│   │       │   ├── products_list_page.dart
│   │       │   ├── product_detail_page.dart
│   │       │   └── cart_page.dart
│   │       └── widgets/
│   │           ├── product_card.dart
│   │           └── cart_item_widget.dart
│   ├── wallet/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── transaction_model.dart
│   │   │   │   └── commission_model.dart
│   │   │   └── repositories/
│   │   │       └── wallet_repository_impl.dart
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── wallet_controller.dart
│   │       ├── pages/
│   │       │   ├── wallet_page.dart
│   │       │   └── withdraw_page.dart
│   │       └── widgets/
│   │           ├── balance_card.dart
│   │           └── transaction_list_item.dart
│   └── dashboard/
│       └── presentation/
│           ├── controllers/
│           │   └── dashboard_controller.dart
│           ├── pages/
│           │   └── dashboard_page.dart
│           └── widgets/
│               ├── stats_card.dart
│               ├── ranking_widget.dart
│               └── monthly_chart.dart
```

### Stack Tecnológico Obrigatório
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # Dependency Injection
  get_it: ^7.6.4
  
  # Navigation
  go_router: ^13.0.0
  
  # HTTP (simulado com dados locais)
  dio: ^5.4.0
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  
  # Code Generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  
  # UI
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  fl_chart: ^0.66.0
  
  # Utils
  intl: ^0.19.0
  uuid: ^4.3.3
  logger: ^2.0.2

dev_dependencies:
  # Build Runner
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1
  
  # Testing
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.2
  
  # Linting
  flutter_lints: ^3.0.1
```

---

## Especificações Detalhadas por Módulo

### Módulo de Autenticação

**Models (Freezed + Json Serializable)**
```dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String referralCode,
    String? referredBy,
    required int points,
    required double balance,
    required DateTime createdAt,
    required bool isActive,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => 
    _$UserModelFromJson(json);
}
```

**Repository Interface**
```dart
abstract class AuthRepository {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String? referralCode,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<void> updateProfile(UserModel user);
}
```

**Controller (Provider)**
```dart
class AuthController extends ChangeNotifier {
  final AuthRepository _repository;
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthController(this._repository);

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      _currentUser = await _repository.login(email: email, password: password);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Falha no login: ${e.toString()}';
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
```

---

### Módulo de Rede Multinível

**Estrutura de Dados**
```dart
@freezed
class NetworkNode with _$NetworkNode {
  const factory NetworkNode({
    required String userId,
    required String userName,
    required String referralCode,
    required int level,
    required int directReferrals,
    required int totalNetwork,
    required double totalCommissions,
    required List<NetworkNode> children,
  }) = _NetworkNode;
}
```

**Widget da Árvore (Simplificado)**
- Usar `CustomPaint` ou biblioteca como `graphview` para visualização
- Exibir até 3 níveis com indicação de "ver mais"
- Cores diferentes por nível (Level 1: verde, Level 2: azul, Level 3: laranja)
- Animações de expansão/colapso

---

### Módulo de Produtos e Carrinho

**Models**
```dart
@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String name,
    required String description,
    required double price,
    required String category,
    required String imageUrl,
    required bool isActive,
  }) = _ProductModel;
}

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required ProductModel product,
    required int quantity,
  }) = _CartItem;
  
  const CartItem._();
  
  double get subtotal => product.price * quantity;
}
```

**Regras de Negócio no Repository**
```dart
class ProductsRepositoryImpl implements ProductsRepository {
  Future<double> calculateCommissions(double purchaseAmount, int level) {
    switch (level) {
      case 1: return purchaseAmount * 0.10;
      case 2: return purchaseAmount * 0.05;
      case 3: return purchaseAmount * 0.02;
      default: return 0.0;
    }
  }
}
```

---

### Módulo de Carteira

**Transactions**
```dart
enum TransactionType {
  commission,
  pointsConversion,
  purchase,
  withdrawal,
  bonus,
}

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required TransactionType type,
    required double amount,
    required DateTime timestamp,
    required String description,
    String? relatedUserId,
  }) = _TransactionModel;
}
```

**Conversão de Pontos**
- 100 pontos = R$ 10,00
- Conversão irreversível
- Mínimo 100 pontos para converter

---

## Design System

### Paleta de Cores
```dart
class AppColors {
  static const primary = Color(0xFF0066FF);
  static const secondary = Color(0xFF00C853);
  static const accent = Color(0xFFFF9800);
  
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFF44336);
  
  static const background = Color(0xFFF5F5F5);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
}
```

### Tipografia
```dart
class AppTextStyles {
  static const headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  // ... outros estilos
}
```

### Componentes Reutilizáveis

**CustomButton**
```dart
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;

  const CustomButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: _getButtonStyle(),
      child: isLoading 
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label),
    );
  }
}
```

---

## Dados Mockados

### Produtos Iniciais (20 produtos mínimo)
```dart
final mockProducts = [
  ProductModel(
    id: '1',
    name: 'Curso de Flutter Avançado',
    description: 'Aprenda Flutter do zero ao avançado',
    price: 497.00,
    category: 'Cursos',
    imageUrl: 'https://placeholder.com/300x200',
    isActive: true,
  ),
  ProductModel(
    id: '2',
    name: 'Smartphone Samsung Galaxy S23',
    description: 'Último lançamento com câmera de 200MP',
    price: 3499.00,
    category: 'Eletrônicos',
    imageUrl: 'https://placeholder.com/300x200',
    isActive: true,
  ),
  // ... mais 18 produtos
];
```

### Usuários Iniciais para Teste
- Criar 10 usuários mockados com rede já estruturada (3 níveis)
- Usuário admin: `admin@central.com` / senha: `Admin@123`
- Usuários com diferentes quantidades de indicados e comissões

---

## Rotas (GoRouter)

```dart
final router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final authController = context.read<AuthController>();
    final isAuthenticated = authController.isAuthenticated;
    final isAuthRoute = state.matchedLocation.startsWith('/login') ||
                        state.matchedLocation.startsWith('/register');

    if (!isAuthenticated && !isAuthRoute) return '/login';
    if (isAuthenticated && isAuthRoute) return '/dashboard';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductsListPage(),
    ),
    GoRoute(
      path: '/products/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailPage(productId: id);
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      path: '/network',
      builder: (context, state) => const NetworkTreePage(),
    ),
    GoRoute(
      path: '/wallet',
      builder: (context, state) => const WalletPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);
```

---

## Testes Obrigatórios

### Unit Tests
```dart
// test/modules/auth/auth_controller_test.dart
void main() {
  late AuthController controller;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    controller = AuthController(mockRepository);
  });

  test('login com sucesso deve atualizar currentUser', () async {
    final user = UserModel(/* ... */);
    when(() => mockRepository.login(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => user);

    await controller.login('test@test.com', 'password');

    expect(controller.currentUser, equals(user));
    expect(controller.isAuthenticated, isTrue);
  });

  // ... mais testes
}
```

### Widget Tests
```dart
// test/modules/auth/presentation/pages/login_page_test.dart
void main() {
  testWidgets('LoginPage deve renderizar campos de email e senha', 
    (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LoginPage()),
    );

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
```

---

## Critérios de Aceite

### Funcionalidade
- [ ] Cadastro e login funcionais com validações
- [ ] Código de indicação gerado automaticamente e único
- [ ] Rede multinível visualizável até 3 níveis
- [ ] Pontos atribuídos corretamente (100 indicador, 50 indicado)
- [ ] Catálogo com mínimo 20 produtos
- [ ] Carrinho funcional com adicionar/remover
- [ ] Comissões calculadas corretamente (10%, 5%, 2%)
- [ ] Carteira exibindo saldo e transações
- [ ] Conversão de pontos (100 pts = R$ 10)
- [ ] Dashboard com estatísticas corretas

### Qualidade de Código
- [ ] Clean Architecture aplicada em todos os módulos
- [ ] Null Safety sem warnings
- [ ] Sem uso de `!` desnecessário
- [ ] Todos os widgets com `const` quando possível
- [ ] Nenhum widget > 300 linhas
- [ ] Nenhuma função > 20 linhas
- [ ] DI configurada com GetIt
- [ ] Providers registrados corretamente
- [ ] Cobertura de testes ≥ 70%

### UI/UX
- [ ] Responsivo em mobile/tablet/desktop
- [ ] Loading states em todas operações assíncronas
- [ ] Mensagens de erro claras
- [ ] Feedback visual em ações (snackbars, dialogs)
- [ ] Navegação fluida sem travamentos
- [ ] Imagens com placeholder e erro tratado
- [ ] Contraste e acessibilidade WCAG AA

---

## Entregáveis

1. **Código-fonte completo** seguindo estrutura especificada
2. **README.md** com:
   - Instruções de instalação
   - Como rodar o projeto
   - Credenciais de teste
   - Prints das principais telas
3. **Documentação de API** (rotas, models, regras de negócio)
4. **Testes automatizados** com cobertura ≥ 70%
5. **Build web** funcional para demonstração

---

## Observações Finais

- **Não usar backend real**: todos os dados devem ser mockados localmente com Hive
- **Simulações**: pagamentos, saques, emails são apenas visuais
- **Performance**: aplicar debounce em buscas, lazy loading em listas
- **Logs**: usar `logger` para debug, sem dados sensíveis
- **Segurança**: senhas devem ser "hasheadas" mesmo localmente (ex: com `crypto`)

**Este é um projeto educacional/protótipo. Nenhuma transação financeira real deve ser implementada.**