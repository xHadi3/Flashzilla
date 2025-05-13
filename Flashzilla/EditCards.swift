//
//  EditCards.swift
//  Flashzilla
//
//  Created by Hadi Al zayer on 15/11/1446 AH.
//

import SwiftUI

struct EditCards: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationStack{
            List{
                Section("Add new cards"){
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add Card", action: addCards)
                }
                
                
                Section(){
                    ForEach(0..<cards.count, id: \.self){ index in
                        VStack(alignment: .leading){
                            Text(cards[index].prompt)
                                .font(.headline)
                            
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar{
                Button("Done", action: done)
            }
            .onAppear(perform: loadData)
        }  
    }
    func done(){
        dismiss()
    }
    func loadData(){
        if let data = UserDefaults.standard.data(forKey: "Cards"){
            if let decoded = try? JSONDecoder().decode([Card].self , from: data){
                cards = decoded
            }
        }
    }
    
    func saveData(){
        if let data = try? JSONEncoder().encode(cards){
            UserDefaults.standard.set(data , forKey: "Cards")
        }
    }
    
    func addCards(){
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else{
            return
        }
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(card , at: 0)
        saveData()
    }
    
    func removeCards(at offset: IndexSet){
        cards.remove(atOffsets: offset)
        saveData()
    }
    
}

#Preview {
    EditCards()
}
