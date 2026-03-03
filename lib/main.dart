import 'package:flutter/material.dart';

void main() => runApp(const EduTachesApp());

const Color figmaBlue = Color(0xFF043686);
const Color figmaLightGrey = Color(0xFFF5F6F9);

class EduTachesApp extends StatelessWidget {
  const EduTachesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edu Tâches Pro',
      theme: ThemeData(
        primaryColor: figmaBlue,
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const MainNavigator(),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  final PageController _controller = PageController();

  void goTo(int page) {
    _controller.animateToPage(page, 
        duration: const Duration(milliseconds: 400), 
        curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          buildWelcomeScreen(() => goTo(1)),
          buildLoginScreen(onLogin: () => goTo(3), onGoToSignup: () => goTo(2)),
          buildSignupScreen(() => goTo(1)),
          const MainAppContainer(), // Contient les 4 écrans de l'appli
        ],
      ),
    );
  }

  // --- 1. ACCUEIL ---
  Widget buildWelcomeScreen(VoidCallback onNext) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 80),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school, color: figmaBlue, size: 40),
              SizedBox(width: 10),
              Text('Edu Tâches', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: figmaBlue)),
            ],
          ),
          const Spacer(),
          Image.network('https://illustrations.popsy.co/blue/online-registration.svg', height: 280),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text("L'organisation au service de votre réussite éducative", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: figmaBlue,
                minimumSize: const Size(double.infinity, 60),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
              ),
              onPressed: onNext,
              child: const Text("Commençons l'aventure", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. CONNEXION ---
  Widget buildLoginScreen({required VoidCallback onLogin, required VoidCallback onGoToSignup}) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Text("Connexion", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: figmaBlue)),
            const SizedBox(height: 40),
            customField("Entrez votre e-mail", Icons.email_outlined),
            const SizedBox(height: 15),
            customField("Entrez votre mot de passe", Icons.lock_outline, isPass: true),
            Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text("Mot de passe oublié ?"))),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: figmaBlue, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: onLogin,
              child: const Text("Se connecter", style: TextStyle(color: Colors.white)),
            ),
            TextButton(onPressed: onGoToSignup, child: const Text("Créer un compte", style: TextStyle(decoration: TextDecoration.underline))),
            const SizedBox(height: 20),
            const Text("OU"),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              socialBtn(Icons.g_mobiledata, Colors.red),
              const SizedBox(width: 20),
              socialBtn(Icons.facebook, Colors.blue),
              const SizedBox(width: 20),
              socialBtn(Icons.window, Colors.blue.shade800),
            ]),
          ],
        ),
      ),
    );
  }

  // --- 3. INSCRIPTION ---
  Widget buildSignupScreen(VoidCallback onBack) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Text("Inscription", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: figmaBlue)),
            const SizedBox(height: 40),
            customField("Nom d'utilisateur", Icons.person_outline),
            const SizedBox(height: 15),
            customField("E-mail", Icons.email_outlined),
            const SizedBox(height: 15),
            customField("Mot de passe", Icons.lock_outline, isPass: true),
            const SizedBox(height: 15),
            customField("Téléphone", Icons.phone_android),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: figmaBlue, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: onBack,
              child: const Text("S'inscrire", style: TextStyle(color: Colors.white)),
            ),
            TextButton(onPressed: onBack, child: const Text("Retour à la connexion")),
          ],
        ),
      ),
    );
  }

  Widget customField(String h, IconData i, {bool isPass = false}) {
    return TextField(obscureText: isPass, decoration: InputDecoration(hintText: h, prefixIcon: Icon(i, color: figmaBlue), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))));
  }

  Widget socialBtn(IconData i, Color c) {
    return Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)), child: Icon(i, color: c, size: 30));
  }
}

// --- CONTENEUR PRINCIPAL APPRÈS CONNEXION ---
class MainAppContainer extends StatefulWidget {
  const MainAppContainer({super.key});
  @override
  State<MainAppContainer> createState() => _MainAppContainerState();
}

class _MainAppContainerState extends State<MainAppContainer> {
  int _currentIndex = 0;
  String _selectedPriority = "Moyen";
  String? _selectedSubject;
  
  // Liste des 15 matières avec logos
  final List<Map<String, dynamic>> _subjects = [
    {'name': 'Mathématiques', 'icon': Icons.calculate},
    {'name': 'Français', 'icon': Icons.menu_book},
    {'name': 'Histoire-Géo', 'icon': Icons.public},
    {'name': 'Sciences (SVT)', 'icon': Icons.biotech},
    {'name': 'Physique-Chimie', 'icon': Icons.science},
    {'name': 'Anglais', 'icon': Icons.language},
    {'name': 'Espagnol', 'icon': Icons.translate},
    {'name': 'Philosophie', 'icon': Icons.psychology},
    {'name': 'Informatique', 'icon': Icons.computer},
    {'name': 'Arts Plastiques', 'icon': Icons.palette},
    {'name': 'Musique', 'icon': Icons.music_note},
    {'name': 'EPS', 'icon': Icons.fitness_center},
    {'name': 'Économie', 'icon': Icons.trending_up},
    {'name': 'Latin', 'icon': Icons.history_edu},
    {'name': 'Technologie', 'icon': Icons.build},
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      buildDashboard(),
      buildAddTask(),
      buildDetails(),
      buildProfile(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: figmaBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_rounded), label: 'Ajouter'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_rounded), label: 'Détails'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: 'Profil'),
        ],
      ),
    );
  }

  // --- 4. DASHBOARD ---
  Widget buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Bonjour, Khadim', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: figmaBlue)),
                Text('Samedi 21 Février 2026', style: TextStyle(color: Colors.grey)),
              ]),
              CircleAvatar(radius: 25, backgroundColor: figmaBlue, child: Icon(Icons.person, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 25),
          searchBar(),
          const SizedBox(height: 25),
          Row(children: [
            priorityBadge("Urgent", Colors.red),
            priorityBadge("Moyen", Colors.orange),
            priorityBadge("Faible", Colors.green),
          ]),
          const SizedBox(height: 25),
          taskItem('Devoir Mathématiques', 'Chapitre Logarithme', '18h-19h', Colors.red),
          taskItem('Lecture Français', 'Le Cid - Corneille', '21h-22h', Colors.orange),
        ],
      ),
    );
  }

  // --- 5. AJOUTER (AVEC LISTE DÉROULANTE) ---
  Widget buildAddTask() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const Text('Ajouter une tâche', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: figmaBlue)),
          const SizedBox(height: 25),
          field("Titre de la tâche", Icons.edit),
          const SizedBox(height: 15),
          
          // LISTE DÉROULANTE MATIÈRES
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(15)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSubject,
                hint: const Row(children: [Icon(Icons.book, color: figmaBlue), SizedBox(width: 10), Text("Sélectionner la matière")]),
                isExpanded: true,
                items: _subjects.map((s) => DropdownMenuItem<String>(
                  value: s['name'],
                  child: Row(children: [Icon(s['icon'], color: figmaBlue, size: 20), const SizedBox(width: 10), Text(s['name'])]),
                )).toList(),
                onChanged: (val) => setState(() => _selectedSubject = val),
              ),
            ),
          ),
          
          const SizedBox(height: 15),
          field("Description", Icons.description, lines: 3),
          const SizedBox(height: 20),
          const Text("Priorité", style: TextStyle(fontWeight: FontWeight.bold)),
          Row(children: [
            choicePriority("Urgent", Colors.red),
            choicePriority("Moyen", Colors.orange),
            choicePriority("Faible", Colors.green),
          ]),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: figmaBlue, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tâche enregistrée !")));
              setState(() => _currentIndex = 0);
            },
            child: const Text("Enregistrer la tâche", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- 6. DÉTAILS ---
  Widget buildDetails() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const Text("Détails de la tâche", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: figmaBlue)),
          const SizedBox(height: 30),
          const Center(child: Icon(Icons.calculate, size: 80, color: figmaBlue)),
          const SizedBox(height: 20),
          const Center(child: Text("Mathématiques : Logarithmes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          const SizedBox(height: 30),
          infoTile("Statut", "En cours", Colors.blue),
          infoTile("Priorité", "Urgent", Colors.red),
          infoTile("Date", "21/02/2026 - 18h", figmaBlue),
          const Spacer(),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Modification activée"))), child: const Text("Modifier"))),
            const SizedBox(width: 15),
            Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: figmaBlue), onPressed: () => setState(() => _currentIndex = 0), child: const Text("Enregistrer", style: TextStyle(color: Colors.white)))),
          ]),
        ],
      ),
    );
  }

  // --- 7. PROFIL ---
  Widget buildProfile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(radius: 60, backgroundColor: figmaBlue, child: Icon(Icons.person, size: 70, color: Colors.white)),
          const SizedBox(height: 20),
          const Text("Khadim BA", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("khadimba1370@gmail.com", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 40),
          ListTile(leading: const Icon(Icons.settings), title: const Text("Paramètres"), onTap: () {}),
          ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text("Déconnexion", style: TextStyle(color: Colors.red)), onTap: () {}),
        ],
      ),
    );
  }

  // --- HELPERS ---
  Widget searchBar() => Container(padding: const EdgeInsets.symmetric(horizontal: 15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)), child: const TextField(decoration: InputDecoration(hintText: 'Rechercher...', border: InputBorder.none, icon: Icon(Icons.search))));
  
  Widget priorityBadge(String t, Color c) => Container(margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Row(children: [CircleAvatar(radius: 4, backgroundColor: c), const SizedBox(width: 5), Text(t, style: TextStyle(color: c, fontSize: 12))]));

  Widget choicePriority(String t, Color c) => GestureDetector(
    onTap: () => setState(() => _selectedPriority = t),
    child: Container(margin: const EdgeInsets.only(right: 10, top: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: _selectedPriority == t ? c : c.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Text(t, style: TextStyle(color: _selectedPriority == t ? Colors.white : c, fontWeight: FontWeight.bold))),
  );

  Widget taskItem(String t, String s, String h, Color c) => Card(margin: const EdgeInsets.only(bottom: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), child: Container(decoration: BoxDecoration(border: Border(left: BorderSide(color: c, width: 6)), borderRadius: BorderRadius.circular(15)), child: ListTile(title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text("$s\n$h"), trailing: const Icon(Icons.chevron_right))));

  Widget field(String h, IconData i, {int lines = 1}) => TextField(maxLines: lines, decoration: InputDecoration(hintText: h, prefixIcon: Icon(i, color: figmaBlue), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))));

  Widget infoTile(String l, String v, Color c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l), Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(8)), child: Text(v, style: const TextStyle(color: Colors.white, fontSize: 12)))]));
}