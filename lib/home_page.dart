import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistance_app/feature_box.dart';
import 'package:voice_assistance_app/openai_service.dart';
import 'package:voice_assistance_app/pallete.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();

  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    speechToText.initialize();  //ask for permission
    setState(() {

    });
  }
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }


  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      print(lastWords);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: BounceInDown(

          child: const Text(
              'Jennie',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //Virtual Assistant Picture
            children: [
              ZoomIn(
                child: Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(top: 4),
                    decoration:  const BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      height: 123,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/virtualAssistant.png'),
                        )
                      ),
                    ),
                  ),
                ),
              ),
              // Chat bubble
              FadeInRight(
                child: Visibility(
                  visible: generatedImageUrl == null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                      top: 30
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Pallete.borderColor,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)).copyWith(
                        topLeft: Radius.zero,
                      )
                    ),
                    child: Text(
                      generatedContent == null ?
                      'Good morning, what task can i do for you ?': generatedContent!,
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallete.mainFontColor,
                        fontSize: generatedContent == null ? 20 : 15,
                      ),
                    ),
                  ),
                ),
              ),
              if(generatedImageUrl != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Image.network(generatedImageUrl!)
                  ),
                ),
              SlideInLeft(
                child: Visibility(
                  visible: generatedContent == null && generatedImageUrl == null,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, left: 22),
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Here are a few features',
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        fontSize: 20,
                        color: Pallete.mainFontColor,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
              //Features List
              Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child:  Column(
                  children: [
                    SlideInLeft(
                      delay: Duration(milliseconds: start),
                      child: const FeatureBox(
                        color: Pallete.firstSuggestionBoxColor,
                        headerText: 'ChatGPT',
                        descriptionText: 'A smarter way to stay organized and informed with ChatGPT',
                      ),
                    ),
                    SlideInLeft(
                      delay: Duration(milliseconds: start + delay),
                      child: const FeatureBox(
                        color: Pallete.secondSuggestionBoxColor,
                        headerText: 'Dall-E',
                        descriptionText: 'Get inspired and stay creative with your personal assistant'
                            ' powered by Dall-E',
                      ),
                    ),
                    SlideInLeft(
                      delay: Duration(milliseconds: start + 2 * delay),
                      child: const FeatureBox(
                        color: Pallete.thirdSuggestionBoxColor,
                        headerText: 'Smart Voice Assistant',
                        descriptionText: 'Get the best both of worlds and a voice assistant'
                            ' powered by Dall-E and ChatGPT',
                      ),
                    )
                  ],
                ),
              ),
              TextFormField(
                onFieldSubmitted: (prompt) async{
                  final speech = await openAIService.isArtPromptAPI(prompt);
                  if(speech.contains('https')){
                    generatedImageUrl = speech;
                    generatedContent = null;
                  }else{
                    generatedImageUrl = null;
                    generatedContent = speech;
                    setState(() {

                    });
                    await systemSpeak(speech);
                  }
                },
                decoration: const InputDecoration(
                  hintText: "Write message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  )
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(
          onPressed: () async{
            if(await speechToText.hasPermission && speechToText.isNotListening){
              await startListening();
            }else if(speechToText.isListening){
              final speech = await openAIService.isArtPromptAPI(lastWords);
              if(speech.contains('https')){
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {
        
                });
              }else {
                generatedImageUrl = null;
                generatedContent = speech;
                setState(() {
        
                });
                await systemSpeak(speech);
              }
              await stopListening();
            }else{
              initSpeechToText();
            }
          },
          backgroundColor: Pallete.firstSuggestionBoxColor,
          child: const Icon(Icons.keyboard_voice),
        ),
      ),
    
    );
  }
}
