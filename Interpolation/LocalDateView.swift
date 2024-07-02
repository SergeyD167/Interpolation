//
//  LocalDateView.swift
//  Interpolation
//
//  Created by Сергей Дятлов on 02.07.2024.
//

import SwiftUI

struct LocalDateView: View {
    
    @State private var selectedDate = Date()
    @State private var selectedLocale = Locale(identifier: "ru_RU")
    @State private var selectedFlag = 0
    
    private let locales = [
        Locale(identifier: "ru_RU"),
        Locale(identifier: "en_US"),
        Locale(identifier: "fr_FR"),
        Locale(identifier: "de_DE"),
        Locale(identifier: "es_ES")
    ]
    
    private let flags = ["🇷🇺", "🇺🇸", "🇫🇷", "🇩🇪", "🇪🇸"]
    
    private let labels = [
        ["Позавчера", "Вчера", "Сегодня", "Завтра", "Послезавтра"],
        ["The day before yesterday", "Yesterday", "Today", "Tomorrow", "The day after tomorrow"],
        ["Avant-hier", "Hier", "Aujourd'hui", "Demain", "Après-demain"],
        ["Vorgestern", "Gestern", "Heute", "Morgen", "Übermorgen"],
        ["Anteayer", "Ayer", "Hoy", "Mañana", "Pasado mañana"]
    ]
    
    var body: some View {
        VStack {
            Text("Select the date and your location")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            Picker("Select Language", selection: $selectedFlag) {
                ForEach(0..<flags.count) { index in
                    Text(self.flags[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selectedFlag) { _, newValue in
                selectedLocale = locales[newValue]
            }
            
            ScrollView {
                VStack(spacing: 10) {
                    Text("\(labels[selectedFlag][0]): \(spellOut: selectedDate.addingTimeInterval(-172800), locale: selectedLocale)")
                    Text("\(labels[selectedFlag][1]): \(spellOut: selectedDate.addingTimeInterval(-86400), locale: selectedLocale)")
                    Text("\(labels[selectedFlag][2]): \(spellOut: selectedDate, locale: selectedLocale)").font(.headline)
                    Text("\(labels[selectedFlag][3]): \(spellOut: selectedDate.addingTimeInterval(86400), locale: selectedLocale)")
                    Text("\(labels[selectedFlag][4]): \(spellOut: selectedDate.addingTimeInterval(172800), locale: selectedLocale)")
                }
                .multilineTextAlignment(.center)
                .padding()
            }
            .scrollIndicators(.hidden)
        }
        .padding()
    }
}

private extension String.StringInterpolation {
    mutating func appendInterpolation(spellOut date: Date, locale: Locale) {
        let dayFormatter = DateFormatter()
        dayFormatter.locale = locale
        dayFormatter.dateFormat = "EEEE"

        let dayComponent = dayFormatter.string(from: date)
        
        let dateComponents = Calendar.current.dateComponents([.day, .month], from: date)
        let day = dateComponents.day ?? 0
        let month = dateComponents.month ?? 0
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale
        numberFormatter.numberStyle = .spellOut
        
        let dayString = numberFormatter.string(from: NSNumber(value: day)) ?? ""
        let monthString = dayFormatter.monthSymbols[month - 1]

        let formattedDate = "\(dayComponent), \(dayString) \(monthString)"
        appendLiteral(formattedDate)
    }
}
#Preview {
    LocalDateView()
}
