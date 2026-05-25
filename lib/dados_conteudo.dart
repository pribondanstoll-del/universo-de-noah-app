// ============================================================
// DADOS DE CONTEÚDO — Universo de Noah
// Toda a estrutura pedagógica do app fica aqui
// ============================================================

class Palavra {
  final String ingles;
  final String portugues;
  final String emoji;
  final String pronuncia;
  final String audioFile;

  const Palavra({
    required this.ingles,
    required this.portugues,
    required this.emoji,
    required this.pronuncia,
    required this.audioFile,
  });
}

class MiniJogo {
  final String tipo; // 'toque', 'memoria', 'quiz', 'sequencia'
  final String titulo;
  final String descricao;
  final String emoji;

  const MiniJogo({
    required this.tipo,
    required this.titulo,
    required this.descricao,
    required this.emoji,
  });
}

class Licao {
  final int numero;
  final String titulo;
  final List<Palavra> palavrasNovas;
  final List<Palavra> palavrasRevisao;
  final List<MiniJogo> miniJogos;
  final List<String> frases;
  final List<Map<String, String>> quiz;
  final bool primeiraLicao;

  const Licao({
    required this.numero,
    required this.titulo,
    required this.palavrasNovas,
    required this.palavrasRevisao,
    required this.miniJogos,
    required this.frases,
    required this.quiz,
    this.primeiraLicao = false,
  });
}

class Fase {
  final int numero;
  final String titulo;
  final String emoji;
  final String descricao;
  final List<Licao> licoes;

  const Fase({
    required this.numero,
    required this.titulo,
    required this.emoji,
    required this.descricao,
    required this.licoes,
  });
}

class Nivel {
  final int numero;
  final String titulo;
  final String emoji;
  final String descricao;
  final String medalha;
  final List<Fase> fases;
  final List<Map<String, String>> quizBoss;

  const Nivel({
    required this.numero,
    required this.titulo,
    required this.emoji,
    required this.descricao,
    required this.medalha,
    required this.fases,
    required this.quizBoss,
  });
}

// ============================================================
// MENSAGENS DO NOAH
// ============================================================

class MensagensNoah {
  static const List<String> acerto = [
    "Yes! That's right! 🌟",
    "Wow, you're amazing! ⭐",
    "You got it! High five! 🙌",
    "Superstar! ✨",
    "Incredible! Keep going! 🚀",
    "You're on fire! 🔥",
  ];

  static const List<String> acertoTrad = [
    "Sim! Isso mesmo!",
    "Uau, você é incrível!",
    "Você conseguiu! Toca aqui!",
    "Superestrela!",
    "Incrível! Continue assim!",
    "Você está arrasando!",
  ];

  static const List<String> erro = [
    "Oops! Try again, you can do it! 💪",
    "Almost! So close! 🎯",
    "Don't give up! Noah believes in you! 🌟",
    "That's okay! Mistakes help us learn! 📚",
    "You'll get it next time! 🌈",
  ];

  static const List<String> erroTrad = [
    "Ops! Tente de novo, você consegue!",
    "Quase! Tão pertinho!",
    "Não desista! Noah acredita em você!",
    "Tudo bem! Os erros nos ajudam a aprender!",
    "Da próxima vez você pega!",
  ];

  static const List<String> revisao = [
    "Remember me? Let's warm up! 🔥",
    "Quick memory check! Ready? ⚡",
    "Noah is testing your memory! 🧠",
    "You learned this before — show me! 💫",
  ];

  static const List<String> revisaoTrad = [
    "Lembra de mim? Vamos aquecer!",
    "Teste rápido de memória! Pronto?",
    "Noah está testando sua memória!",
    "Você aprendeu isso antes — me mostra!",
  ];

  static const List<String> conclusao = [
    "Lesson complete! You're incredible! 🏆",
    "The Noah Universe is proud of you! 🌟",
    "New badge unlocked! Keep exploring! 🗺️",
  ];

  static const List<String> conclusaoTrad = [
    "Lição completa! Você é incrível!",
    "O Universo de Noah está orgulhoso de você!",
    "Nova medalha desbloqueada! Continue explorando!",
  ];
}

// ============================================================
// NÍVEL 1 — PRIMEIROS PASSOS
// ============================================================

const nivel1 = Nivel(
  numero: 1,
  titulo: 'Primeiros Passos',
  emoji: '🌱',
  descricao: 'Suas primeiras palavras em inglês!',
  medalha: 'Explorador Iniciante',
  quizBoss: [
    {'pergunta': 'Como o Noah diz "bom dia" em inglês?', 'resposta': 'Good morning', 'a': 'Good morning', 'b': 'Good night', 'c': 'Goodbye', 'd': 'Thank you'},
    {'pergunta': 'Qual saudação usamos quando vamos dormir?', 'resposta': 'Good night', 'a': 'Good morning', 'b': 'Good afternoon', 'c': 'Good night', 'd': 'Hello'},
    {'pergunta': 'Como respondemos quando alguém diz "Thank you"?', 'resposta': "You're welcome", 'a': 'Hello', 'b': 'Goodbye', 'c': "You're welcome", 'd': 'Please'},
    {'pergunta': 'Qual a cor do céu?', 'resposta': 'Blue', 'a': 'Red', 'b': 'Blue', 'c': 'Green', 'd': 'Yellow'},
    {'pergunta': 'Como se diz "cinco" em inglês?', 'resposta': 'Five', 'a': 'Four', 'b': 'Six', 'c': 'Five', 'd': 'Three'},
    {'pergunta': 'O animal que late é o...', 'resposta': 'Dog', 'a': 'Cat', 'b': 'Fish', 'c': 'Bird', 'd': 'Dog'},
    {'pergunta': 'Como se diz "elefante" em inglês?', 'resposta': 'Elephant', 'a': 'Lion', 'b': 'Tiger', 'c': 'Elephant', 'd': 'Bear'},
    {'pergunta': 'Como se diz "morango" em inglês?', 'resposta': 'Strawberry', 'a': 'Apple', 'b': 'Strawberry', 'c': 'Banana', 'd': 'Grape'},
    {'pergunta': 'A apple é de que cor?', 'resposta': 'Red', 'a': 'Blue', 'b': 'Yellow', 'c': 'Green', 'd': 'Red'},
    {'pergunta': 'Que número vem depois de "nine"?', 'resposta': 'Ten', 'a': 'Eight', 'b': 'Eleven', 'c': 'Ten', 'd': 'Seven'},
  ],
  fases: [

    // ==================== FASE 1 — SAUDAÇÕES ====================
    Fase(
      numero: 1,
      titulo: 'Saudações',
      emoji: '👋',
      descricao: 'Como cumprimentar e se despedir em inglês',
      licoes: [
        Licao(
          numero: 1,
          titulo: 'Hello e Goodbye',
          primeiraLicao: true,
          palavrasNovas: [
            Palavra(ingles: 'Hello', portugues: 'Olá', emoji: '😊', pronuncia: 'HEH-loh', audioFile: 'hello'),
            Palavra(ingles: 'Hi', portugues: 'Oi', emoji: '✋', pronuncia: 'HAI', audioFile: 'hi'),
            Palavra(ingles: 'Good morning', portugues: 'Bom dia', emoji: '🌅', pronuncia: 'gud MOR-ning', audioFile: 'good_morning'),
            Palavra(ingles: 'Goodbye', portugues: 'Tchau', emoji: '👋', pronuncia: 'gud-BAI', audioFile: 'goodbye'),
          ],
          palavrasRevisao: [],
          miniJogos: [
            MiniJogo(tipo: 'toque', titulo: 'Escuta e Toca', descricao: 'Noah fala a saudação. Toque na imagem correta!', emoji: '🎧'),
            MiniJogo(tipo: 'quiz', titulo: 'Qual Momento É Esse?', descricao: 'Noah está chegando ou saindo? Escolha a saudação certa!', emoji: '🎭'),
          ],
          frases: [
            'Hello! My name is Noah. — Olá! Meu nome é Noah.',
            'Goodbye! See you soon! — Tchau! Até logo!',
          ],
          quiz: [
            {'pergunta': 'Como o Noah diz "olá" de forma mais formal?', 'resposta': 'Hello', 'a': 'Hello', 'b': 'Goodbye', 'c': 'Hi', 'd': 'Good morning'},
            {'pergunta': 'Noah está chegando na escola. O que ele diz?', 'resposta': 'Hello', 'a': 'Goodbye', 'b': 'Hello', 'c': 'Good morning', 'd': 'Hi'},
            {'pergunta': 'Qual saudação usamos de manhã?', 'resposta': 'Good morning', 'a': 'Hi', 'b': 'Hello', 'c': 'Good morning', 'd': 'Goodbye'},
            {'pergunta': 'Noah está indo embora. O que ele fala?', 'resposta': 'Goodbye', 'a': 'Hello', 'b': 'Hi', 'c': 'Good morning', 'd': 'Goodbye'},
          ],
        ),
        Licao(
          numero: 2,
          titulo: 'Thank you e Welcome',
          palavrasNovas: [
            Palavra(ingles: 'Good afternoon', portugues: 'Boa tarde', emoji: '☀️', pronuncia: 'gud af-ter-NOON', audioFile: 'good_afternoon'),
            Palavra(ingles: 'Good night', portugues: 'Boa noite', emoji: '🌙', pronuncia: 'gud NAIT', audioFile: 'good_night'),
            Palavra(ingles: 'Thank you', portugues: 'Obrigado', emoji: '💛', pronuncia: 'THANK yoo', audioFile: 'thank_you'),
            Palavra(ingles: "You're welcome", portugues: 'De nada', emoji: '😄', pronuncia: 'yor WEL-kem', audioFile: 'youre_welcome'),
          ],
          palavrasRevisao: [
            Palavra(ingles: 'Hello', portugues: 'Olá', emoji: '😊', pronuncia: 'HEH-loh', audioFile: 'hello'),
            Palavra(ingles: 'Hi', portugues: 'Oi', emoji: '✋', pronuncia: 'HAI', audioFile: 'hi'),
            Palavra(ingles: 'Good morning', portugues: 'Bom dia', emoji: '🌅', pronuncia: 'gud MOR-ning', audioFile: 'good_morning'),
          ],
          miniJogos: [
            MiniJogo(tipo: 'toque', titulo: 'Que Hora É?', descricao: 'Cenas do dia aparecem. Escolha a saudação certa!', emoji: '🌞'),
            MiniJogo(tipo: 'quiz', titulo: 'Troca de Gentilezas', descricao: 'Noah fez algo legal. Como você responde?', emoji: '🤝'),
          ],
          frases: [
            'Good afternoon! How are you? — Boa tarde! Como você está?',
            'Thank you very much, Noah! — Muito obrigado, Noah!',
          ],
          quiz: [
            {'pergunta': 'Noah está jantando. Que saudação usa?', 'resposta': 'Good night', 'a': 'Good morning', 'b': 'Good afternoon', 'c': 'Good night', 'd': 'Hello'},
            {'pergunta': 'Alguém te ajudou. O que você diz?', 'resposta': 'Thank you', 'a': 'Goodbye', 'b': 'Thank you', 'c': 'Hello', 'd': 'Hi'},
            {'pergunta': 'Como respondemos quando alguém diz "Thank you"?', 'resposta': "You're welcome", 'a': 'Hello', 'b': 'Goodbye', 'c': "You're welcome", 'd': 'Good night'},
            {'pergunta': 'É de tarde. Noah chega. O que ele diz?', 'resposta': 'Good afternoon', 'a': 'Good morning', 'b': 'Good night', 'c': 'Goodbye', 'd': 'Good afternoon'},
          ],
        ),
      ],
    ),

    // ==================== FASE 2 — CORES ====================
    Fase(
      numero: 2,
      titulo: 'Cores',
      emoji: '🎨',
      descricao: 'As cores do mundo do Noah',
      licoes: [
        Licao(
          numero: 1,
          titulo: 'As primeiras cores',
          palavrasNovas: [
            Palavra(ingles: 'Red', portugues: 'Vermelho', emoji: '🔴', pronuncia: 'RED', audioFile: 'red'),
            Palavra(ingles: 'Blue', portugues: 'Azul', emoji: '🔵', pronuncia: 'BLOO', audioFile: 'blue'),
            Palavra(ingles: 'Yellow', portugues: 'Amarelo', emoji: '🟡', pronuncia: 'YEH-loh', audioFile: 'yellow'),
            Palavra(ingles: 'Green', portugues: 'Verde', emoji: '🟢', pronuncia: 'GREEN', audioFile: 'green'),
          ],
          palavrasRevisao: [
            Palavra(ingles: 'Hello', portugues: 'Olá', emoji: '😊', pronuncia: 'HEH-loh', audioFile: 'hello'),
            Palavra(ingles: 'Thank you', portugues: 'Obrigado', emoji: '💛', pronuncia: 'THANK yoo', audioFile: 'thank_you'),
            Palavra(ingles: 'Goodbye', portugues: 'Tchau', emoji: '👋', pronuncia: 'gud-BAI', audioFile: 'goodbye'),
          ],
          miniJogos: [
            MiniJogo(tipo: 'toque', titulo: 'Pinta com o Noah', descricao: 'Ouça a cor e toque na tinta certa!', emoji: '🎨'),
            MiniJogo(tipo: 'quiz', titulo: 'Caça a Cor', descricao: 'Encontre tudo que é da cor certa!', emoji: '🔍'),
          ],
          frases: [
            'The sky is blue. — O céu é azul.',
            'Apples are red. — Maçãs são vermelhas.',
          ],
          quiz: [
            {'pergunta': 'Qual a cor do céu?', 'resposta': 'Blue', 'a': 'Red', 'b': 'Blue', 'c': 'Green', 'd': 'Yellow'},
            {'pergunta': 'Como se diz "amarelo" em inglês?', 'resposta': 'Yellow', 'a': 'Green', 'b': 'Red', 'c': 'Blue', 'd': 'Yellow'},
            {'pergunta': 'A grama é green ou red?', 'resposta': 'Green', 'a': 'Red', 'b': 'Blue', 'c': 'Green', 'd': 'Yellow'},
            {'pergunta': 'Noah tem uma bola azul. Como ele diria?', 'resposta': 'Blue', 'a': 'Green', 'b': 'Yellow', 'c': 'Red', 'd': 'Blue'},
          ],
        ),
        Licao(
          numero: 2,
          titulo: 'Mais cores',
          palavrasNovas: [
            Palavra(ingles: 'Orange', portugues: 'Laranja', emoji: '🟠', pronuncia: 'OR-enj', audioFile: 'orange'),
            Palavra(ingles: 'Purple', portugues: 'Roxo', emoji: '🟣', pronuncia: 'PUR-pel', audioFile: 'purple'),
            Palavra(ingles: 'Pink', portugues: 'Rosa', emoji: '🌸', pronuncia: 'PINK', audioFile: 'pink'),
            Palavra(ingles: 'White', portugues: 'Branco', emoji: '⬜', pronuncia: 'WAIT', audioFile: 'white'),
          ],
          palavrasRevisao: [
            Palavra(ingles: 'Red', portugues: 'Vermelho', emoji: '🔴', pronuncia: 'RED', audioFile: 'red'),
            Palavra(ingles: 'Blue', portugues: 'Azul', emoji: '🔵', pronuncia: 'BLOO', audioFile: 'blue'),
            Palavra(ingles: 'Yellow', portugues: 'Amarelo', emoji: '🟡', pronuncia: 'YEH-loh', audioFile: 'yellow'),
          ],
          miniJogos: [
            MiniJogo(tipo: 'memoria', titulo: 'Arco-íris do Noah', descricao: 'Arraste cada cor para o lugar certo!', emoji: '🌈'),
            MiniJogo(tipo: 'toque', titulo: 'Diz a Cor!', descricao: 'Que cor é essa? Toque na resposta certa!', emoji: '🎤'),
          ],
          frases: [
            "Noah's shirt is orange! — A camiseta do Noah é laranja!",
            'The clouds are white. — As nuvens são brancas.',
          ],
          quiz: [
            {'pergunta': 'Como se diz "rosa" em inglês?', 'resposta': 'Pink', 'a': 'Purple', 'b': 'Pink', 'c': 'Orange', 'd': 'White'},
            {'pergunta': 'Noah veste uma camisa roxa. Que cor é essa?', 'resposta': 'Purple', 'a': 'Pink', 'b': 'Orange', 'c': 'Purple', 'd': 'White'},
            {'pergunta': 'Neve é white ou orange?', 'resposta': 'White', 'a': 'Orange', 'b': 'Pink', 'c': 'Purple', 'd': 'White'},
            {'pergunta': 'Como se diz "laranja" em inglês?', 'resposta': 'Orange', 'a': 'Pink', 'b': 'White', 'c': 'Purple', 'd': 'Orange'},
          ],
        ),
        Licao(
          numero: 3,
          titulo: 'Últimas cores',
          palavrasNovas: [
            Palavra(ingles: 'Black', portugues: 'Preto', emoji: '⬛', pronuncia: 'BLAK', audioFile: 'black'),
            Palavra(ingles: 'Brown', portugues: 'Marrom', emoji: '🟫', pronuncia: 'BRAWN', audioFile: 'brown'),
            Palavra(ingles: 'Gray', portugues: 'Cinza', emoji: '🔘', pronuncia: 'GRAY', audioFile: 'gray'),
          ],
          palavrasRevisao: [
            Palavra(ingles: 'Orange', portugues: 'Laranja', emoji: '🟠', pronuncia: 'OR-enj', audioFile: 'orange'),
            Palavra(ingles: 'Purple', portugues: 'Roxo', emoji: '🟣', pronuncia: 'PUR-pel', audioFile: 'purple'),
            Palavra(ingles: 'Pink', portugues: 'Rosa', emoji: '🌸', pronuncia: 'PINK', audioFile: 'pink'),
          ],
          miniJogos: [
            MiniJogo(tipo: 'quiz', titulo: 'De Que Cor É?', descricao: 'Objetos aparecem. Escolha a cor certa!', emoji: '📦'),
            MiniJogo(tipo: 'memoria', titulo: 'Quadro do Noah', descricao: 'Complete a pintura com as cores certas!', emoji: '🖌️'),
          ],
          frases: [
            'The cat is black. — O gato é preto.',
            'The elephant is gray. — O elefante é cinza.',
          ],
          quiz: [
            {'pergunta': 'Como se diz "preto" em inglês?', 'resposta': 'Black', 'a': 'Gray', 'b': 'Brown', 'c': 'Black', 'd': 'White'},
            {'pergunta': 'O elefante é gray ou pink?', 'resposta': 'Gray', 'a': 'Pink', 'b': 'Gray', 'c': 'Brown', 'd': 'Black'},
            {'pergunta': 'Chocolate é brown ou blue?', 'resposta': 'Brown', 'a': 'Blue', 'b': 'Black', 'c': 'Gray', 'd': 'Brown'},
            {'pergunta': 'Como se diz "cinza" em inglês?', 'resposta': 'Gray', 'a': 'Brown', 'b': 'Black', 'c': 'Gray', 'd': 'White'},
          ],
        ),
      ],
    ),

    // ==================== FASE 3 — NÚMEROS ====================
    Fase(
      numero: 3,
      titulo: 'Números',
      emoji: '🔢',
      descricao: 'Contar e reconhecer números com o Noah',
      licoes: [
        Licao(
          numero: 1,
          titulo: 'One to Five',
          palavrasNovas: [
            Palavra(ingles: 'One', portugues: 'Um', emoji: '1️⃣', pronuncia: 'WAN', audioFile: 'one'),
            Palavra(ingles: 'Two', portugues: 'Dois', emoji: '2️⃣', pronuncia: 'TOO', audioFile: 'two'),
            Palavra(ingles: 'Three', portugues: 'Três', emoji: '3️⃣', pronuncia: 'TREE', audioFile: 'three'),
            Palavra(ingles: 'Four', portugues: 'Quatro', emoji: '4️⃣', pronuncia: 'FOR', audioFile: 'four'),
            Palavra(ingles: 'Five', portugues: 'Cinco', emoji: '5️⃣', pronuncia: 'FAIV', audioFile: 'five'),
          ],
          palavrasRevisao: [
            Palavra(ingles: 'Black', portugues: 'Preto', emoji: '⬛', pronuncia: 'BLAK', audioFile: 'black'),
            Palavra(ingles: 'Brown', portugues: 'Marrom', emoji: '🟫', pronuncia: 'BRAWN', audioFile: 'brown'),
            Palavra(ingles: 'Gray', portugues: 'Cinza', emoji: '🔘', pronuncia: 'GRAY', audioFile: 'gray'),
          ],
          miniJogos: [
            MiniJogo(tipo: 'toque', titulo: 'Conta com o Noah', descricao: 'Noah joga frutas na tela. Conte e toque no número certo!', emoji: '🧮'),
            MiniJogo(tipo: 'quiz', titulo: 'Qual Número É Esse?', descricao: 'Ouça e toque na palavra certa!', emoji: '📱'),
          ],
          frases: [
            'I have two cats. — Eu tenho dois gatos.',
            'Noah is five years old. — Noah tem cinco anos.',
          ],
          quiz: [
            {'pergunta': 'Como se diz "3" em inglês?', 'resposta': 'Three', 'a': 'Two', 'b': 'Four', 'c': 'Three', 'd': 'One'},
            {'pergunta': 'Noah tem 5 bolas. Como falamos "cinco"?', 'resposta': 'Five', 'a': 'Four', 'b': 'Six', 'c': 'Three', 'd': 'Five'},
            {'pergunta': 'Quanto é one + one?', 'resposta': 'Two', 'a': 'Three', 'b': 'Two', 'c': 'One', 'd': 'Four'},
            {'pergunta': 'Qual número vem depois de "four"?', 'resposta': 'Five', 'a': 'Three', 'b': 'Six', 'c': 'Four', 'd': 'Five'},
          ],
        ),
        Licao(
          numero: 2,
          titulo: 'Six to Ten',
          palavrasNovas: [
            Palavra(ingles: 'Six', portugues: 'Seis', emoji: '6️⃣', pronuncia: 'SIKS', audioFile: 'six'),
            Palavra(ingles: 'Seven', portugues: 'Sete', emoji: '7️⃣', pronuncia: 'SEH-ven', audioFile: 'seven'),
            Palavra(ingles: 'Eight', portugues: 'Oito', emoji: '8️⃣', pronuncia: 'AIT', audioFile: 'eight'),
            Palavra(ingles: 'Nine', portugues: 'Nove', emoji: '9️⃣', pronuncia: 'NAIN', audioFile: 'nine'),
            Palavra(ingles: 'Ten', portugues: 'Dez', emoji: '🔟', pronuncia: 'TEN', audioFile: 'ten'),
          ],
          palavrasRevisao: [
            Palavra(ingles: 'One', portugues: 'Um', emoji: '1️⃣', pronuncia: 'WAN', audioFile: 'one'),
            Palavra(ingles: 'Two', portugues: 'Dois', emoji: '2️⃣', pronuncia: 'TOO', audioFile: 'two'),
            Palavra(ingles: 'Five', portugues: 'Cinco', emoji: '5️⃣', pronuncia: 'FAIV', audioFile: 'five'),
          ],
          miniJogos: [
            MiniJogo(tipo: 'quiz', titulo: 'Dado do Noah', descricao: 'Noah joga dados. Some e responda em inglês!', emoji: '🎲'),
            MiniJogo(tipo: 'toque', titulo: 'Corrida dos Números', descricao: 'Toque no número que Noah falou antes que desapareça!', emoji: '🏃'),
          ],
          frases: [
            'There are seven days in a week. — Há sete dias em uma semana.',
            'I have ten fingers! — Eu tenho dez dedos!',
          ],
          quiz: [
            {'pergunta': 'Sete em inglês é...', 'resposta': 'Seven', 'a': 'Six', 'b': 'Seven', 'c': 'Eight', 'd': 'Nine'},
            {'pergunta': 'Noah tem ten dedos. Quantos são?', 'resposta': 'Ten', 'a': 'Eight', 'b': 'Nine', 'c': 'Ten', 'd': 'Six'},
            {'pergunta': 'Que número vem depois de "eight"?', 'resposta': 'Nine', 'a': 'Seven', 'b': 'Ten', 'c': 'Nine', 'd': 'Six'},
            {'pergunta': 'Como se diz "seis" em inglês?', 'resposta': 'Six', 'a': 'Seven', 'b': 'Eight', 'c': 'Six', 'd': 'Nine'},
          ],
        ),
      ],
    ),

    // ==================== FASE 4 — ANIMAIS ====================
    Fase(
      numero: 4,
      titulo: 'Animais',
      emoji: '🐾',
      descricao: 'O zoológico do Noah',
      licoes: [
        Licao(
          numero: 1,
          titulo: 'Animais de estimação',
          palavrasNovas: [
            Palavra(ingles: 'Dog', portugues: 'Cachorro', emoji: '🐶', pronuncia: 'DOG', audioFile: 'dog'),
            Palavra(ingles: 'Cat', portugues: 'Gato', emoji: '🐱', pronuncia: 'KAT', audioFile: 'cat'),
            Palavra(ingles: 'Bird', portugues: 'Pássaro', emoji: '🐦', pronuncia: 'BERD', audioFile: 'bird'),
            Palavra(ingles: 'Fish', portugues: 'Peixe', emoji: '🐟', pronuncia: 'FISH', audioFile: 'fish'),
          ],
          palavrasRevisao: [
            Palavra(ingles: 'Six', portugues: 'Seis', emoji: '6️⃣', pronuncia: 'SIKS', audioFile: 'six'),
            Palavra(ingles: 'Seven', portugues: 'Sete', emoji: '7️⃣', pronuncia: 'SEH-ven', audioFile: 'seven'),
            Palavra(ingles: 'Ten', portugues: 'Dez', emoji: '🔟', pronuncia: 'TEN', audioFile: 'ten'),
          ],
          miniJogos: [
            MiniJogo(tipo: 'toque', titulo: 'Que Animal É Esse?', descricao: 'Ouça o som do animal e toque no correto!', emoji: '🔊'),
            MiniJogo(tipo: 'memoria', titulo: 'Memória dos Animais', descricao: 'Encontre os pares de cartas!', emoji: '🃏'),
          ],
          frases: [
            'I have a dog and a cat. — Eu tenho um cachorro e um gato.',
            'The bird can fly! — O pássaro consegue voar!',
          ],
          quiz: [
            {'pergunta': 'Como se diz "gato" em inglês?', 'resposta': 'Cat', 'a': 'Dog', 'b': 'Cat', 'c': 'Bird', 'd': 'Fish'},
            {'pergunta': 'Noah tem um animal que late. Que animal é?', 'resposta': 'Dog', 'a': 'Cat', 'b': 'Fish', 'c': 'Bird', 'd': 'Dog'},
            {'pergunta': 'Fish vive na água ou no ar?', 'resposta': 'Água', 'a': 'Ar', 'b': 'Água', 'c': 'Terra', 'd': 'Árvore'},
            {'pergunta': 'Como se diz "pássaro" em inglês?', 'resposta': 'Bird', 'a': 'Fish', 'b': 'Cat', 'c': 'Dog', 'd': 'Bird'},
          ],
        ),
        Licao(
          numero: 2,
          titulo: 'Animais da fazenda',
          palavrasNovas: [
            Palavra(ingles: 'Rabbit', portugues: 'Coelho', emoji: '🐰', pronuncia: 'RAB-it', audioFile: 'rabbit'),
            Palavra(ingles: 'Horse', portugues: 'Cavalo', emoji: '🐴', pronuncia: 'HORS', audioFile: 'horse'),
            Palavra(ingles: 'Cow', portugues: 'Vaca', emoji: '🐄', pronuncia: 'KAW', audioFile: 'cow'),
            Palavra(ingles: 'Pig', portugues: 'Porco', emoji: '🐷', pronuncia: 'PIG', audioFile: 'pig'),
          ],
          palavrasRevisao: [
            Palavra(ingles: 'Dog', portugues: 'Cachorro', emoji: '🐶', pronuncia: 'DOG', audioFile: 'dog'),
            Palavra(ingles: 'Cat', portugues: 'Gato', emoji: '🐱', pronuncia: 'KAT', audioFile: 'cat'),
            Palavra(ingles: 'Bird', portugues: 'Pássaro', emoji: '🐦', pronuncia: 'BERD', audioFile: 'bird'),
          ],
          miniJogos: [
            MiniJogo(tipo: 'quiz', titulo: 'Fazenda do Noah', descricao: 'Arraste cada animal para o lugar correto!', emoji: '🏕️'),
            MiniJogo(tipo: 'toque', titulo: 'Imita o Animal!', descricao: 'Que animal é esse? Toque na resposta!', emoji: '🎤'),
          ],
          frases: [
            'The cow says moo! — A vaca faz muuu!',
            'Noah loves horses! — Noah adora cavalos!',
          ],
          quiz: [
            {'pergunta': 'Como se diz "coelho" em inglês?', 'resposta': 'Rabbit', 'a': 'Horse', 'b': 'Cow', 'c': 'Rabbit', 'd': 'Pig'},
            {'pergunta': 'Qual animal dá leite?', 'resposta': 'Cow', 'a': 'Pig', 'b': 'Rabbit', 'c': 'Horse', 'd': 'Cow'},
            {'pergunta': 'Noah monta em um animal. Qual é?', 'resposta': 'Horse', 'a': 'Fish', 'b': 'Bird', 'c': 'Horse', 'd': 'Rabbit'},
            {'pergunta': 'Como se diz "porco" em inglês?', 'resposta': 'Pig', 'a': 'Cow', 'b': 'Horse', 'c': 'Rabbit', 'd': 'Pig'},
          ],
        ),
      ],
    ),

    // ==================== FASE 5 — FRUTAS ====================
    Fase(
      numero: 5,
      titulo: 'Frutas',
      emoji: '🍎',
      descricao: 'O mercadinho de frutas do Noah',
      licoes: [
        Licao(
          numero: 1,
          titulo: 'Primeiras frutas',
          palavrasNovas: [
            Palavra(ingles: 'Apple', portugues: 'Maçã', emoji: '🍎', pronuncia: 'AP-el', audioFile: 'apple'),
            Palavra(ingles: 'Banana', portugues: 'Banana', emoji: '🍌', pronuncia: 'beh-NA-na', audioFile: 'banana'),
            Palavra(ingles: 'Orange', portugues: 'Laranja', emoji: '🍊', pronuncia: 'OR-enj', audioFile: 'orange_fruit'),
            Palavra(ingles: 'Grape', portugues: 'Uva', emoji: '🍇', pronuncia: 'GREIP', audioFile: 'grape'),
          ],
          palavrasRevisao: [
            Palavra(ingles: 'Dog', portugues: 'Cachorro', emoji: '🐶', pronuncia: 'DOG', audioFile: 'dog'),
            Palavra(ingles: 'Cat', portugues: 'Gato', emoji: '🐱', pronuncia: 'KAT', audioFile: 'cat'),
            Palavra(ingles: 'Rabbit', portugues: 'Coelho', emoji: '🐰', pronuncia: 'RAB-it', audioFile: 'rabbit'),
          ],
          miniJogos: [
            MiniJogo(tipo: 'quiz', titulo: 'Mercadinho do Noah', descricao: 'Selecione as frutas certas da lista!', emoji: '🛒'),
            MiniJogo(tipo: 'toque', titulo: 'De Que Cor É a Fruta?', descricao: 'Combine a fruta com a cor certa!', emoji: '🎨'),
          ],
          frases: [
            'The apple is red. — A maçã é vermelha.',
            'I love grapes! — Eu amo uvas!',
          ],
          quiz: [
            {'pergunta': 'Como se diz "maçã" em inglês?', 'resposta': 'Apple', 'a': 'Grape', 'b': 'Banana', 'c': 'Apple', 'd': 'Orange'},
            {'pergunta': 'A banana é yellow ou red?', 'resposta': 'Yellow', 'a': 'Red', 'b': 'Yellow', 'c': 'Green', 'd': 'Blue'},
            {'pergunta': 'Grape é uva ou laranja?', 'resposta': 'Uva', 'a': 'Laranja', 'b': 'Uva', 'c': 'Maçã', 'd': 'Banana'},
            {'pergunta': 'Noah vai ao mercado comprar uma apple. Que fruta é?', 'resposta': 'Maçã', 'a': 'Banana', 'b': 'Uva', 'c': 'Maçã', 'd': 'Laranja'},
          ],
        ),
        Licao(
          numero: 2,
          titulo: 'Frutas tropicais',
          palavrasNovas: [
            Palavra(ingles: 'Strawberry', portugues: 'Morango', emoji: '🍓', pronuncia: 'STRAW-ber-ee', audioFile: 'strawberry'),
            Palavra(ingles: 'Watermelon', portugues: 'Melancia', emoji: '🍉', pronuncia: 'WAH-ter-mel-en', audioFile: 'watermelon'),
            Palavra(ingles: 'Mango', portugues: 'Manga', emoji: '🥭', pronuncia: 'MAN-goh', audioFile: 'mango'),
            Palavra(ingles: 'Pineapple', portugues: 'Abacaxi', emoji: '🍍', pronuncia: 'PAIN-ap-el', audioFile: 'pineapple'),
          ],
          palavrasRevisao: [
            Palavra(ingles: 'Apple', portugues: 'Maçã', emoji: '🍎', pronuncia: 'AP-el', audioFile: 'apple'),
            Palavra(ingles: 'Banana', portugues: 'Banana', emoji: '🍌', pronuncia: 'beh-NA-na', audioFile: 'banana'),
            Palavra(ingles: 'Grape', portugues: 'Uva', emoji: '🍇', pronuncia: 'GREIP', audioFile: 'grape'),
          ],
          miniJogos: [
            MiniJogo(tipo: 'quiz', titulo: 'Faz o Suco!', descricao: 'Arraste as frutas certas para o liquidificador!', emoji: '🍹'),
            MiniJogo(tipo: 'toque', titulo: 'Qual Fruta Sou Eu?', descricao: 'Noah dá dicas. Adivinhe a fruta!', emoji: '❓'),
          ],
          frases: [
            'Noah loves watermelon! — Noah adora melancia!',
            'Strawberries are red and sweet. — Morangos são vermelhos e doces.',
          ],
          quiz: [
            {'pergunta': 'Como se diz "morango" em inglês?', 'resposta': 'Strawberry', 'a': 'Mango', 'b': 'Strawberry', 'c': 'Pineapple', 'd': 'Watermelon'},
            {'pergunta': 'Watermelon é grande ou pequena?', 'resposta': 'Grande', 'a': 'Pequena', 'b': 'Grande', 'c': 'Média', 'd': 'Minúscula'},
            {'pergunta': 'Fruta tropical amarela com espinhos?', 'resposta': 'Pineapple', 'a': 'Mango', 'b': 'Strawberry', 'c': 'Pineapple', 'd': 'Watermelon'},
            {'pergunta': 'Como se diz "melancia" em inglês?', 'resposta': 'Watermelon', 'a': 'Strawberry', 'b': 'Pineapple', 'c': 'Mango', 'd': 'Watermelon'},
          ],
        ),
      ],
    ),
  ],
);

// Lista com todos os níveis
const List<Nivel> todosOsNiveis = [nivel1];