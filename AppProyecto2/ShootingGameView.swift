import SwiftUI
import AVFoundation
import AVKit

struct Player: View {
    var position: CGPoint
    var spaceshipImage: String
    
    var body: some View {
        Image(spaceshipImage)
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .rotationEffect(spaceshipImage.contains("cohete") ? .degrees(-90) : .degrees(0))
            .shadow(color: .pink, radius: 10, x: 0, y: 0)
            .position(position)
    }
}
//c
struct Bullet: View {
    let position: CGPoint
    
    var body: some View {
        Circle()
            .fill(Color.pink)
            .frame(width: 8, height: 8)
            .shadow(color: .pink.opacity(0.5), radius: 5, x: 0, y: 0)
            .position(position)
    }
}

struct Target: View {
    let position: CGPoint
    let onDisappear: () -> Void
    
    var body: some View {
        Image("estrella")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .shadow(color: .yellow.opacity(0.5), radius: 5, x: 0, y: 0)
            .position(position)
            .onAppear {
                // Desaparecer después de 3 segundos
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    onDisappear()
                }
            }
    }
}

struct TransitionView: View {
    let onComplete: () -> Void
    @State private var showMessage = false
    @State private var player: AVPlayer?
    
    var body: some View {
        ZStack {
            // Fondo con la imagen cielorosita
            Image("cielorosita")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Capa semi-transparente para mejorar la visibilidad
            Color(red: 1.0, green: 0.9, blue: 0.95)
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Video de la gatita
                if let player = player {
                    VideoPlayer(player: player)
                        .frame(width: 300, height: 300)
                        .cornerRadius(20)
                        .shadow(color: .pink.opacity(0.3), radius: 10)
                }
                
                // Mensaje de buena suerte
                if showMessage {
                    Text("¡La Reina Chio te desea mucha suerte!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 1.0, green: 0.9, blue: 0.95),
                                            Color(red: 0.95, green: 0.85, blue: 0.9)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        )
                        .shadow(color: .pink.opacity(0.2), radius: 10)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(30)
        }
        .onAppear {
            // Configurar y reproducir el video
            if let videoURL = Bundle.main.url(forResource: "catvideo", withExtension: "mp4") {
                let playerItem = AVPlayerItem(url: videoURL)
                
                // Configurar el tiempo de inicio y fin (en segundos)
                let startTime = CMTime(seconds: 8.0, preferredTimescale: 600) // Comienza en 5 segundos
                let endTime = CMTime(seconds: 11.0, preferredTimescale: 600)   // Termina en 8 segundos
                
                // Crear el player con el rango de tiempo
                player = AVPlayer(playerItem: playerItem)
                
                // Observar cuando el video llega al tiempo final
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                     object: playerItem,
                                                     queue: .main) { _ in
                    // Volver al tiempo de inicio
                    player?.seek(to: startTime)
                    player?.play()
                }
                
                // Establecer el tiempo inicial
                player?.seek(to: startTime)
                player?.play()
            }
            
            // Mostrar el mensaje después de un breve retraso
            withAnimation(.easeIn(duration: 0.5)) {
                showMessage = true
            }
            
            // Cerrar la vista después de que termine el video
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                player?.pause()
                onComplete()
            }
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
}

struct StoryView: View {
    let onClose: () -> Void
    @State private var showTransition = false
    
    var body: some View {
        ZStack {
            // Fondo semi-transparente con tono rosa
            Color(red: 1.0, green: 0.9, blue: 0.95)
                .opacity(0.95)
                .edgesIgnoringSafeArea(.all)
            
            if showTransition {
                TransitionView(onComplete: onClose)
            } else {
                // Contenedor de la historia
                VStack(spacing: 20) {
                    // Título
                    Text("La Historia de la Reina Chio")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.6))
                        .shadow(color: .pink.opacity(0.3), radius: 5)
                    
                    // Imagen de la gatita
                    Image("cat")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .shadow(color: .pink.opacity(0.5), radius: 10)
                    
                    // Historia
                    Text("¡Hola, valiente piloto! Soy la Reina Chio, una gatita espacial que necesita tu ayuda. Las estrellas malvadas están invadiendo nuestro reino espacial y necesitamos detenerlas. ¿Me ayudarás a proteger nuestro hogar?")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 1.0, green: 0.9, blue: 0.95),
                                            Color(red: 0.95, green: 0.85, blue: 0.9)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: .pink.opacity(0.2), radius: 10)
                        )
                    
                    // Botón de cerrar
                    Button(action: {
                        withAnimation {
                            showTransition = true
                        }
                    }) {
                        Text("¡Vamos a Jugar!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 1.0, green: 0.8, blue: 0.9),
                                                Color(red: 0.9, green: 0.7, blue: 0.9)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: .pink.opacity(0.3), radius: 10)
                            )
                    }
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 1.0, green: 0.95, blue: 0.98),
                                    Color(red: 0.98, green: 0.9, blue: 0.95)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .pink.opacity(0.2), radius: 20)
                )
                .padding(20)
            }
        }
    }
}

// Estructura para las naves
struct Spaceship {
    let name: String
    let imageName: String
    let description: String
    let specialAbility: String
}

struct SpaceshipSelectionView: View {
    let onSelect: (Spaceship) -> Void
    @State private var selectedShip: Spaceship?
    
    let spaceships = [
        Spaceship(
            name: "Nave Clásica",
            imageName: "spaceship",
            description: "La nave perfecta para principiantes",
            specialAbility: "Velocidad equilibrada"
        ),
        Spaceship(
            name: "Cohete Rosita",
            imageName: "coheterosita",
            description: "Para pilotos que buscan velocidad",
            specialAbility: "Movimiento más rápido"
        ),
        Spaceship(
            name: "Cohete Morado",
            imageName: "cohetemorado",
            description: "Ideal para sobrevivir más tiempo",
            specialAbility: "Escudo temporal"
        ),
        Spaceship(
            name: "UFO Colorido",
            imageName: "ufocolorsitos",
            description: "Nave especial con poderes únicos",
            specialAbility: "Disparo triple"
        ),
        Spaceship(
            name: "UFO Morado",
            imageName: "ufomorado",
            description: "La nave más poderosa",
            specialAbility: "Puntuación doble"
        ),
        Spaceship(
            name: "UFO Morado Despegando",
            imageName: "ufomoradocute",
            description: "La nave más cute",
            specialAbility: "Puntuación cute"
        ),
        Spaceship(
            name: "UFO Chaparrito",
            imageName: "ufochaparrito",
            description: "La nave más pequeña, pero es muy poderosa",
            specialAbility: "Puntuación mini"
        ),
        Spaceship(
            name: "UFO Masculino",
            imageName: "ufomasculino",
            description: "La nave masculina, si es que no quieres una rosita",
            specialAbility: "Escudo Poderoso"
        ),
        Spaceship(
            name: "Cohete Colorido",
            imageName: "cohetecolorido",
            description: "El cohete poderoso por sus colores",
            specialAbility: "Colores Poderosos"
        )
        
        
    ]
    
    var body: some View {
        ZStack {
            // Fondo
            Image("fondorositacielo")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Elige tu Nave")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .pink, radius: 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(spaceships, id: \.name) { ship in
                            VStack {
                                Image(ship.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .shadow(color: .pink.opacity(0.5), radius: 10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(selectedShip?.name == ship.name ? Color.pink : Color.clear, lineWidth: 3)
                                    )
                                
                                Text(ship.name)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.6))
                                
                                Text(ship.description)
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 120)
                                
                                Text("Habilidad: \(ship.specialAbility)")
                                    .font(.system(size: 11))
                                    .foregroundColor(.yellow)
                                    .padding(.top, 5)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 1.0, green: 0.9, blue: 0.95),
                                                Color(red: 0.95, green: 0.85, blue: 0.9)
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            )
                            .onTapGesture {
                                withAnimation {
                                    selectedShip = ship
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                if let selected = selectedShip {
                    Button(action: {
                        onSelect(selected)
                    }) {
                        Text("¡Jugar con \(selected.name)!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 1.0, green: 0.8, blue: 0.9),
                                                Color(red: 0.9, green: 0.7, blue: 0.9)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: .pink.opacity(0.3), radius: 10)
                    }
                    .padding(.top, 20)
                }
            }
            .padding()
        }
    }
}

struct StartScreen: View {
    let onStart: (String) -> Void
    @State private var showStory = false
    @State private var showShipSelection = false
    @State private var backgroundMusic: AVAudioPlayer?
    @State private var storyButtonSound: AVAudioPlayer?
    
    var body: some View {
        ZStack {
            // Fondo
            Image("fondorositacielo")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Space Shooter")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .pink, radius: 10)
                
                Text("Cute Version")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.pink.opacity(0.9))
                    .shadow(color: .white, radius: 3)
                    .padding(.bottom, 30)
                
                Button(action: {
                    showShipSelection = true
                }) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("Iniciar Juego")
                            .font(.title2)
                            .fontWeight(.bold)
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 1.0, green: 0.8, blue: 0.9),
                                        Color(red: 0.9, green: 0.7, blue: 0.9)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: .pink.opacity(0.3), radius: 10)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.8), lineWidth: 2)
                    )
                }
                .scaleEffect(1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: true)
                
                // Botón de Historia
                Button(action: { showStory = true }) {
                    HStack {
                        Image(systemName: "book.fill")
                            .foregroundColor(.yellow)
                        Text("La Historia")
                            .font(.title3)
                            .fontWeight(.bold)
                        Image(systemName: "book.fill")
                            .foregroundColor(.yellow)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.9, green: 0.7, blue: 0.9),
                                        Color(red: 0.8, green: 0.6, blue: 0.9)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: .pink.opacity(0.3), radius: 8)
                }
                .padding(.top, 20)
            }
        }
        .overlay(
            Group {
                if showStory {
                    StoryView(onClose: { showStory = false })
                }
                if showShipSelection {
                    SpaceshipSelectionView { selectedShip in
                        showShipSelection = false
                        onStart(selectedShip.imageName)
                    }
                }
            }
        )
        .onAppear {
            // Configurar y reproducir la música de fondo
            if let musicURL = Bundle.main.url(forResource: "chimesonwind", withExtension: "wav") {
                do {
                    backgroundMusic = try AVAudioPlayer(contentsOf: musicURL)
                    backgroundMusic?.numberOfLoops = -1
                    backgroundMusic?.volume = 0.5
                    backgroundMusic?.play()
                } catch {
                    print("Error al cargar la música: \(error.localizedDescription)")
                }
            }
            
            // Configurar el sonido del botón de historia
            if let soundURL = Bundle.main.url(forResource: "storybutton", withExtension: "wav") {
                do {
                    storyButtonSound = try AVAudioPlayer(contentsOf: soundURL)
                    storyButtonSound?.prepareToPlay()
                } catch {
                    print("Error al cargar el sonido del botón: \(error.localizedDescription)")
                }
            }
        }
        .onDisappear {
            backgroundMusic?.stop()
        }
    }
}

struct MovingBackground: View {
    @State private var offset: CGFloat = 0
    @State private var speed: Double = 8 // Duración inicial más rápida (8 segundos)
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            // Primera capa del fondo
            Image("fondorositacielo")
                .resizable()
                .scaledToFill()
                .offset(y: offset)
            
            // Segunda capa del fondo (para crear un efecto continuo)
            Image("fondorositacielo")
                .resizable()
                .scaledToFill()
                .offset(y: offset - UIScreen.main.bounds.height)
        }
        .onAppear {
            startAnimation()
            // Timer para aumentar la velocidad cada 3 segundos
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                increaseSpeed()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    func startAnimation() {
        withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
            offset = UIScreen.main.bounds.height
        }
    }
    
    func increaseSpeed() {
        // Aumentar la velocidad más rápidamente (reducir la duración en un 40%)
        speed = max(2, speed * 0.6) // Permitir que sea más rápido, mínimo 2 segundos
        
        // Reiniciar la animación con la nueva velocidad
        withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
            offset = UIScreen.main.bounds.height
        }
    }
}

struct ShootingGameView: View {
    @State private var isGameStarted = false
    @State private var playerPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    @State private var bullets: [CGPoint] = []
    @State private var targets: [(id: UUID, position: CGPoint)] = []
    @State private var score = 0
    @State private var gameTimer: Timer?
    @State private var lastDragPosition: CGPoint?
    @State private var starTimer: Timer?
    @State private var gameTime: Int = 0
    @State private var currentSpeed: Double = 8
    @State private var shootSound: AVAudioPlayer?
    @State private var selectedSpaceship: String = "spaceship" // Valor por defecto
    
    var body: some View {
        if !isGameStarted {
            StartScreen { selectedShip in
                selectedSpaceship = selectedShip
                isGameStarted = true
                startGame()
            }
        } else {
            ZStack {
                // Fondo en movimiento
                MovingBackground()
                    .edgesIgnoringSafeArea(.all)
                
                // Player (nave espacial)
                Player(position: playerPosition, spaceshipImage: selectedSpaceship)
                
                // Bullets
                ForEach(bullets.indices, id: \.self) { index in
                    Bullet(position: bullets[index])
                }
                
                // Targets
                ForEach(targets, id: \.id) { target in
                    Target(position: target.position) {
                        if let index = targets.firstIndex(where: { $0.id == target.id }) {
                            targets.remove(at: index)
                            createNewTarget()
                        }
                    }
                }
                
                // Score
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .shadow(color: .yellow.opacity(0.5), radius: 5)
                    
                    Text("Score: \(score)")
                        .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.6))
                        .font(.system(size: 28, weight: .bold))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 1.0, green: 0.9, blue: 0.95),
                                    Color(red: 0.95, green: 0.85, blue: 0.9)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .pink.opacity(0.3), radius: 10)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.8), lineWidth: 2)
                )
                .position(x: 100, y: 100)
                
                // Botón de pausa
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            // Detener los timers
                            gameTimer?.invalidate()
                            starTimer?.invalidate()
                            // Detener la música de fondo si hay
                            shootSound?.stop()
                            // Regresar a la pantalla principal
                            isGameStarted = false
                        }) {
                            Image(systemName: "pause.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                                .background(
                                    Circle()
                                        .fill(Color.pink.opacity(0.7))
                                )
                                .shadow(color: .pink.opacity(0.5), radius: 5)
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        playerPosition = value.location
                    }
            )
            .onTapGesture { location in
                shoot(at: location)
            }
        }
    }
    
    func startGame() {
        // Configurar el sonido de disparo
        if let soundURL = Bundle.main.url(forResource: "shoot", withExtension: "wav") {
            do {
                shootSound = try AVAudioPlayer(contentsOf: soundURL)
                shootSound?.prepareToPlay()
                shootSound?.volume = 0.4 // Ajustar el volumen al 70%
            } catch {
                print("Error al cargar el sonido: \(error.localizedDescription)")
            }
        }
        
        // Crear estrellas iniciales
        let initialStarCount = Int.random(in: 5...10)
        for _ in 0..<initialStarCount {
            createNewTarget()
        }
        
        // Timer para el juego
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            updateGame()
        }
        
        // Timer para crear nuevas estrellas aleatoriamente y actualizar la velocidad
        starTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            // 30% de probabilidad de crear una nueva estrella cada segundo
            if Double.random(in: 0...1) < 0.3 {
                createNewTarget()
            }
            gameTime += 1
            // Actualizar la velocidad mostrada
            currentSpeed = max(2, 8 * pow(0.6, Double(gameTime / 3)))
        }
    }
    
    func shoot(at location: CGPoint) {
        let bullet = CGPoint(x: playerPosition.x, y: playerPosition.y)
        bullets.append(bullet)
        
        // Reproducir sonido de disparo
        shootSound?.currentTime = 0
        shootSound?.play()
    }
    
    func createNewTarget() {
        // Solo crear una nueva estrella si no hay demasiadas
        if targets.count < 10 {
            let randomX = CGFloat.random(in: 50...(UIScreen.main.bounds.width - 50))
            let randomY = CGFloat.random(in: 50...(UIScreen.main.bounds.height - 200))
            targets.append((id: UUID(), position: CGPoint(x: randomX, y: randomY)))
        }
    }
    
    func updateGame() {
        // Update bullet positions
        bullets = bullets.map { bullet in
            CGPoint(x: bullet.x, y: bullet.y - 10)
        }.filter { bullet in
            bullet.y > 0
        }
        
        // Check for collisions
        for (bulletIndex, bullet) in bullets.enumerated() {
            for (targetIndex, target) in targets.enumerated() {
                let distance = sqrt(pow(bullet.x - target.position.x, 2) + pow(bullet.y - target.position.y, 2))
                if distance < 30 {
                    // Collision detected
                    score += 10
                    targets.remove(at: targetIndex)
                    bullets.remove(at: bulletIndex)
                    createNewTarget()
                    break
                }
            }
        }
    }
}

#Preview {
    ShootingGameView()
} 
