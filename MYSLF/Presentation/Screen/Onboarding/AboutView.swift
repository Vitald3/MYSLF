//
//  AboutView.swift
//  MYSLF
//
//  Created by Vitald3 on 19.10.2025.
//

import SwiftUI

struct AboutView: View {
    @StateObject var viewModel: OnboardingViewModel
    @EnvironmentObject var router: NavigationRouter

    @State private var taked = false
    @State private var notifyVissible = false
    @State private var step = 3
    @State private var checked: [Bool]
    @State private var checked2: [Bool]
    @State private var checked3: [Bool]
    @State private var shapeFeelingChecked = 1
    @State private var zoneChecked = 0
    @State private var shapeClosestChecked = 0
    @State private var focusFirst: [TextBloc]
    @State private var shapeFeeling: [TextBloc]
    @State private var focusGoals: [TextBloc]
    @State private var planLimitations: [TextBloc]
    
    private let zones = [
        "Full Body",
        "Arms",
        "Chest",
        "Belly",
        "Glutes",
        "Legs",
    ]
    
    private let shapeClosest = [
        "Rectangle",
        "Hourglass",
        "Pear",
        "Round"
    ]

    let request: RegisterDeviceRequest?

    init(viewModel: OnboardingViewModel, request: RegisterDeviceRequest?) {
        self.request = request
        
        let first = [
            TextBloc(title: "Lose weight", text: "Shed excess fat"),
            TextBloc(title: "Love myself", text: "Accept my body"),
            TextBloc(title: "Build muscle", text: "Get stronger"),
            TextBloc(title: "Stay in shape", text: "Feel good physically"),
            TextBloc(title: "Boost endurance", text: "Handle effort more easily"),
            TextBloc(title: "Reduce stress", text: "Calm body and mind"),
            TextBloc(title: "Get into a routine", text: "Find stability")
        ]

        let shapeFeeling = [
            TextBloc(title: "I'm in great shape right now"),
            TextBloc(title: "Less than a year ago"),
            TextBloc(title: "1–2 years ago"),
            TextBloc(title: "More than 3 years ago"),
            TextBloc(title: "Never")
        ]

        let goals = [
            TextBloc(title: "Meal plans", text: "I want a comprehensive menu for quick results"),
            TextBloc(title: "Calorie tracker", text: "I want to know how much protein, fat, and carbs I consume"),
            TextBloc(title: "Workout plans", text: "I want to get in shape and build definition"),
            TextBloc(title: "Fasting", text: "I want to lose weight and improve digestion"),
            TextBloc(title: "Hydration tracking", text: "I want to drink enough water and stay hydrated"),
            TextBloc(title: "Sleep tracking and recovery", text: "I want to improve my sleep quality and monitor my sleep patterns"),
            TextBloc(title: "Daily step goals", text: "I want to walk more and reach my daily activity goal")
        ]
        
        let planLimitations = [
            TextBloc(title: "No, thanks"),
            TextBloc(title: "Sensitive back"),
            TextBloc(title: "Sensitive knees"),
            TextBloc(title: "Recovery"),
            TextBloc(title: "Pregnancy"),
            TextBloc(title: "Postpartum"),
            TextBloc(title: "Postpartum"),
            TextBloc(title: "Joint issues"),
            TextBloc(title: "Blood pressure issues"),
        ]

        _focusFirst = State(initialValue: first)
        _shapeFeeling = State(initialValue: shapeFeeling)
        _focusGoals = State(initialValue: goals)
        _planLimitations = State(initialValue: planLimitations)
        _checked = State(initialValue: Array(repeating: false, count: first.count))
        _checked2 = State(initialValue: Array(repeating: false, count: goals.count))
        _checked3 = State(initialValue: Array(repeating: false, count: planLimitations.count))
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Image("welcome1")
                .resizable()
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                if !viewModel.isNotify && notifyVissible {
                    Push()
                } else {
                    Header(step: $step, count: 7, title: "About you")
                    
                    ScrollView {
                        VStack {
                            switch step {
                            case 0:
                                StepView(
                                    title: "What do you want to focus on first?",
                                    content: focusFirst,
                                    checked: $checked
                                )
                            case 1:
                                StepRadioView(
                                    title: "When was the last time you felt in your best shape?",
                                    content: shapeFeeling,
                                    checkedIndex: $shapeFeelingChecked,
                                    helperText: "This helps me understand your starting point and plan the right pace for you."
                                )
                            case 2:
                                StepView(
                                    title: "What do you want to focus on?",
                                    content: focusGoals,
                                    checked: $checked2
                                )
                            case 3:
                                StepView(
                                    title: "Would you like to add any limitations or special needs to your plan?",
                                    content: planLimitations,
                                    checked: $checked3
                                )
                            case 4:
                                GridType(
                                    zones: zones,
                                    title: "Which area needs the most attention?",
                                    checked: $zoneChecked
                                )
                            case 5:
                                GridType(
                                    zones: shapeClosest,
                                    title: "Which body shape is closest to yours?",
                                    checked: $shapeClosestChecked,
                                    height: 160
                                )
                            default:
                                EmptyView()
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }

                Spacer()
                
                VStack(spacing: 12) {
                    if step == 5 {
                        PrimaryButton(
                            title: "Take a photo",
                            background: Color("AppBox"),
                            borderColor: Color("one-color"),
                            textColor: Color("one-color"),
                            loading: taked
                        ) {
                            taked = true
                            
                            router.push(.camera) { camera in
                                if let camera = camera as? UIImage {
                                    Task {
                                        if let zone = await viewModel.getClosest(camera), shapeClosest.contains(zone) {
                                            shapeClosestChecked = shapeClosest
                                                .firstIndex(of: zone)!
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    PrimaryButton(title: buttonText, isEnabled: isEnabled) {
                        handleContinue()
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 28, bottom: 12 + UIApplication.shared.safeAreaInsets.bottom, trailing: 28))
                .background(Color("AppBox"))
                .cornerRadius(
                    16,
                    corners: [.topLeft, .topRight]
                )
                .shadow(
                  color: Color(red: 0, green: 0, blue: 0, opacity: 0.06), radius: 28
                )
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var buttonText: String {
        if notifyVissible {
            return "Enable notification"
        }
        switch step {
        case 4: return "Build my workout plan"
        default: return "Continue"
        }
    }

    private var isEnabled: Bool {
        switch step {
        case 0: return checked.contains(true)
        case 1,4,5: return true
        case 2: return checked2.contains(true)
        case 3: return checked3.contains(true)
        default: return false
        }
    }

    private func handleContinue() {
        if step == 2 {
            if !viewModel.isNotify && !notifyVissible {
                notifyVissible = true
                
                AppDI.shared.pushService.configure { _ in
                    step += 1
                }
            } else {
                step += 1
            }
        } else if step == 6 {
            let selectedFirst = focusFirst.enumerated().compactMap { checked[$0.offset] ? $0.element.title : nil }
            let selectedGoals = focusGoals.enumerated().compactMap { checked2[$0.offset] ? $0.element.title : nil }

            let updated = request?.copyWith(
                focusFirst: selectedFirst,
                lastBestShapeFeeling: shapeFeeling[shapeFeelingChecked].title,
                focusGoal: selectedGoals
            )

            if !viewModel.isNotify {
                router.push(.empty, with: updated)
            } else {
                router.push(.empty, with: updated)
            }
        } else {
            step += 1
        }
    }
}

#Preview {
    AboutView(viewModel: OnboardingViewModel(
        router: NavigationRouter(), useCase: AppDI.shared.onboardingUseCase
    ), request: nil)
}
