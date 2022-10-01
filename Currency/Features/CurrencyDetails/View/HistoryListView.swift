//
//  HistoryListView.swift
//  Currency
//
//  Created by Mohamed Samir on 30/09/2022.
//

import SwiftUI

struct HistoryListView: View {
    
     @EnvironmentObject var historyModel: HistoryModel
    
    
    var body: some View {
        List {
                
                if  historyModel.history.isEmpty {
                    Spacer()
                    Spacer()
                    Text("No History Data found")
                }else{
                    if historyModel.history.count >= 1 {
                        if !historyModel.history[0].isEmpty {
                            BuildListView(historyList: historyModel.history[0])
                        }
                    }
                   
                    if historyModel.history.count >= 2  {
                        if !historyModel.history[1].isEmpty {
                            BuildListView(historyList: historyModel.history[1])
                        }
                    }
                    
                    if historyModel.history.count >= 3  {
                        if !historyModel.history[2].isEmpty {
                            BuildListView(historyList: historyModel.history[2])
                        }
                    }
                }
               
               
            }.listStyle(SidebarListStyle())
        
    }
}

struct BuildListView: View{
    
    var historyList: [CurHistoryEntity]
    
    var body: some View {
        
        Section {
            ForEach(historyList, id: \.id ) { singleElement in
                let text: String =
                "\(String(format: "%.2f", singleElement.fromAmount))" + " " +
                "\(singleElement.fromCurrency ?? "")" + " -> " +
                "\(String(format: "%.2f", singleElement.toAmount))" + " " +
                "\(singleElement.toCurrency ?? "")"
               
                Text(text)
            }
        } header: {
            Text("Day: \((historyList.first?.date?.get(.day)) ?? 0)")
        }
    }
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListView()
    }
}
