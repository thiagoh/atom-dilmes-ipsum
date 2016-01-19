{CompositeDisposable} = require 'atom'

module.exports = AtomDilmesIpsum =
  subscriptions: null
  phrases: null
  debug: false
  activate: (state) ->

    @phrases = ["Eu, para ir, eu faço uma escala. Para voltar, eu faço duas, para voltar para o Brasil. Neste caso agora nós tínhamos uma discussão. Eu tinha que sair de Zurique, podia ir para Boston, ou pra Boston, até porque... vocês vão perguntar, mas é mais longe? Não é não, a Terra é curva, viu?",
              "É interessante que muitas vezes no Brasil, você é, como diz o povo brasileiro, muitas vezes você é criticado por ter o cachorro e, outras vezes, por não ter o mesmo cachorro. Esta é uma crítica interessante que acontece no Brasil",
              "E nós criamos um programa que eu queria falar para vocês, que é o Ciência sem Fronteiras. Por que eu queria falar do Ciência sem Fronteiras para vocês? É que em todas as demais... porque nós vamos fazer agora o Ciência sem Fronteiras 2. O 1 é o 100 000, mas vai ter de continuar fazendo Ciência sem Fronteiras no Brasil",
              "Eu dou dinheiro pra minha filha. Eu dou dinheiro pra ela viajar, então é... é... Já vivi muito sem dinheiro, já vivi muito com dinheiro. -Jornalista: Coloca esse dinheiro na poupança que a senhora ganha R$10 mil por mês. -Dilma: O que que é R$10 mil?",
              "A única área que eu acho, que vai exigir muita atenção nossa, e aí eu já aventei a hipótese de até criar um ministério. É na área de... Na área... Eu diria assim, como uma espécie de analogia com o que acontece na área agrícola.",
              "Primeiro eu queria cumprimentar os internautas. -Oi Internautas! Depois dizer que o meio ambiente é sem dúvida nenhuma uma ameaça ao desenvolvimento sustentável. E isso significa que é uma ameaça pro futuro do nosso planeta e dos nossos países. O desemprego beira 20%, ou seja, 1 em cada 4 portugueses.",
              "Se hoje é o dia das crianças... Ontem eu disse: o dia da criança é o dia da mãe, dos pais, das professoras, mas também é o dia dos animais, sempre que você olha uma criança, há sempre uma figura oculta, que é um cachorro atrás. O que é algo muito importante!",
              "Todos as descrições das pessoas são sobre a humanidade do atendimento, a pessoa pega no pulso, examina, olha com carinho. Então eu acho que vai ter outra coisa, que os médicos cubanos trouxeram pro brasil, um alto grau de humanidade.",
              "No meu xinélo da humildade eu gostaria muito de ver o Neymar e o Ganso. Por que eu acho que.... 11 entre 10 brasileiros gostariam. Você veja, eu já vi, parei de ver. Voltei a ver, e acho que o Neymar e o Ganso têm essa capacidade de fazer a gente olhar.",
              "A população ela precisa da Zona Franca de Manaus, porque na Zona franca de Manaus, não é uma zona de exportação, é uma zona para o Brasil. Portanto ela tem um objetivo, ela evita o desmatamento, que é altamente lucravito. Derrubar arvores da natureza é muito lucrativo!",
              "Ai você fala o seguinte: \"- Mas vocês acabaram isso?\" Vou te falar: -\"Não, está em andamento!\" Tem obras que \"vai\" durar pra depois de 2010. Agora, por isso, nós já não desenhamos, não começamos a fazer projeto do que nós \"podêmo fazê\"? 11, 12, 13, 14... Por que é que não?"
              "Eu queria destacar uma questão, que é uma questão que está afetando o Brasil inteiro, que é a questão da vigilância sanitária: gente, é o vírus Aedes aegypti, com as suas diferentes modalidades: chikungunya, zika vírus."];
    if @debug
      console.log 'AtomDilmesIpsum activate was called! 2'

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      'atom-dilmes-ipsum:dilmes': => @dilmes(),
      'atom-dilmes-ipsum:dilmesSnippet': (event) => @dilmesSnippet(event)

  deactivate: ->
    @subscriptions.dispose()

  dilmesSnippet: (event) ->
    editor = atom.workspace.getActiveTextEditor()
    if @isDilmesPrefix(editor)
      @doDilmes(editor, true)
    else
      event.abortKeyBinding()

  # Returns `false` if the values aren't the same for all cursors
  isDilmesPrefix: (editor) ->

    for cursor in editor.getCursors()
      position = cursor.getBufferPosition()

      if @debug
        console.log 'isDilmesPrefix position ' + position

      prefixStart = cursor.getBeginningOfCurrentWordBufferPosition()
      cursorSnippetPrefix = editor.getTextInRange([prefixStart, position])

      if @debug
        console.log 'isDilmesPrefix prefixStart ' + prefixStart + ' / ' + cursorSnippetPrefix

      return false if snippetPrefix? and cursorSnippetPrefix isnt snippetPrefix or cursorSnippetPrefix isnt 'dilmes'
      snippetPrefix = cursorSnippetPrefix

    return true if snippetPrefix is 'dilmes'
    return false

  snippetToExpandUnderCursor: (editor) ->
    return false unless editor.getLastSelection().isEmpty()
    snippets = @getSnippets(editor)
    return false if _.isEmpty(snippets)

    if prefixData = @getPrefixText(snippets, editor)
      @snippetForPrefix(snippets, prefixData.snippetPrefix, prefixData.wordPrefix)

  doDilmes: (editor, deleteSnippet) ->

    ix = parseInt(Math.random() * @phrases.length-1)
    sentence = @phrases[ix] + '\n'

    if @debug
      console.debug 'AtomDilmesIpsum was called! Sentence: ' + sentence

    if deleteSnippet
      editor.deleteToBeginningOfWord()

    editor.insertText(sentence)

  dilmes: ->
    if editor = atom.workspace.getActiveTextEditor()
      @doDilmes(editor, false)

    #editors = atom.workspace.getTextEditors()
    #for editor in editors
    #  do (editor) ->
    #    editor.insertText(sentence);
