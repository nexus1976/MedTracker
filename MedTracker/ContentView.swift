//
//  ContentView.swift
//  MedTracker
//
//  Created by Daniel Graham on 1/29/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var viewContext: NSManagedObjectContext
    // @State var entryItem: MedEntry?
    @State private var selectedDate: Date? = nil
    @State private var medEntryId: Date = Date().onlyDate
    @State private var medEntryDose1: Bool = false
    @State private var medEntryDose2: Bool = false
    @State private var medEntryDose3: Bool = false
    @State private var medEntryDose4: Bool = false
    @State private var medEntryDose5: Bool = false
    @State private var medEntryDose6: Bool = false
    @State private var viewId = 0
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        if selectedDate == nil {
            _selectedDate = State(initialValue: Date().onlyDate)
        }
        let entryItem = hydrateData(localDate: selectedDate ?? Date().onlyDate)
        _medEntryId = State(initialValue: entryItem.entityId!)
        _medEntryDose1 = State(initialValue: entryItem.halfDose1)
        _medEntryDose2 = State(initialValue: entryItem.halfDose2)
        _medEntryDose3 = State(initialValue: entryItem.halfDose3)
        _medEntryDose4 = State(initialValue: entryItem.halfDose4)
        _medEntryDose5 = State(initialValue: entryItem.halfDose5)
        _medEntryDose6 = State(initialValue: entryItem.halfDose6)
    }
    
    var buttonSize = 50 as CGFloat?
    var textSize = 200 as CGFloat?
    
    var body: some View {
         NavigationView {
            VStack {
                Form {
                    Toggle("1st half dose taken", isOn: $medEntryDose1).toggleStyle(.switch).tint(.mint)
                        .onChange(of: medEntryDose1) { value in
                            medEntryDose1 = value
                            updateData(localDate: medEntryId)
                        }
                    Toggle("2nd half dose taken", isOn: $medEntryDose2).toggleStyle(.switch).tint(.mint)
                        .onChange(of: medEntryDose2) { value in
                            medEntryDose2 = value
                            updateData(localDate: medEntryId)
                        }
                    Toggle("3rd half dose taken", isOn: $medEntryDose3).toggleStyle(.switch).tint(.mint)
                        .onChange(of: medEntryDose3) { value in
                            medEntryDose3 = value
                            updateData(localDate: medEntryId)
                        }
                    Toggle("4th half dose taken", isOn: $medEntryDose4).toggleStyle(.switch).tint(.mint)
                        .onChange(of: medEntryDose4) { value in
                            medEntryDose4 = value
                            updateData(localDate: medEntryId)
                        }
                    Toggle("5th half dose taken", isOn: $medEntryDose5).toggleStyle(.switch).tint(.mint)
                        .onChange(of: medEntryDose5) { value in
                            medEntryDose5 = value
                            updateData(localDate: medEntryId)
                        }
                    Toggle("6th half dose taken", isOn: $medEntryDose6).toggleStyle(.switch).tint(.mint)
                        .onChange(of: medEntryDose6) { value in
                            medEntryDose6 = value
                            updateData(localDate: medEntryId)
                        }
                }.toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        HStack {
                            Button(action: {
                                print("prev")
                                selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate!)
                                updateForm(localSelectedDate: selectedDate!)
                                viewId += 1
                                print(selectedDate!)
                            }, label: {
                                Text("prev")
                                    .frame(width: buttonSize, height: buttonSize, alignment: .leading)
                                    .padding(.trailing, 0)
                                    .padding(.leading, 0)
                            })
                            Spacer()
                            Text(medEntryId, formatter: itemFormatter).id(viewId)
                                .frame(width: textSize, height: buttonSize, alignment: .center)
                                .padding(.trailing, 0)
                                .padding(.leading, 20)
                            Spacer()
                            Button(action: {
                                print("next")
                                selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate!)
                                updateForm(localSelectedDate: selectedDate!)
                                viewId += 1
                                print(selectedDate!)
                            }, label: {
                                Text("next")
                                    .frame(width: buttonSize, height: buttonSize, alignment: .trailing)
                                    .padding(.trailing, 20)
                            })
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            print("today")
                            selectedDate = Date()
                            updateForm(localSelectedDate: selectedDate!)
                            viewId += 1
                            print(selectedDate!)
                        }, label: {
                            Text("Go To Today")
                        })
                    }
                }
            }
        }
    }
    private func updateForm(localSelectedDate: Date) -> Void {
        let entryItem = hydrateData(localDate: localSelectedDate)
        medEntryId = entryItem.entityId!
        medEntryDose1 = entryItem.halfDose1
        medEntryDose2 = entryItem.halfDose2
        medEntryDose3 = entryItem.halfDose3
        medEntryDose4 = entryItem.halfDose4
        medEntryDose5 = entryItem.halfDose5
        medEntryDose6 = entryItem.halfDose6
    }
    private func hydrateData(localDate: Date) -> MedEntry {
        var localEntry: MedEntry?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MedEntry")
        // request.entity = MedEntry.entity()
        request.sortDescriptors = [NSSortDescriptor(key: "entityId", ascending: true)]
        request.predicate = NSPredicate(format: "entityId == %@", localDate.onlyDate as CVarArg)
        do {
            let items = try viewContext.fetch(request) as! [MedEntry]
            if !items.isEmpty {
                localEntry = items.first
            }
            if localEntry == nil {
                localEntry = MedEntry(context: viewContext)
                localEntry?.entityId = localDate.onlyDate
                localEntry?.halfDose1 = false;
                localEntry?.halfDose2 = false;
                localEntry?.halfDose3 = false;
                localEntry?.halfDose4 = false;
                localEntry?.halfDose5 = false;
                localEntry?.halfDose6 = false;
                try? viewContext.save()
            }
            
            return localEntry!
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    private func updateData(localDate: Date) -> Void {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MedEntry")
        // request.entity = MedEntry.entity()
        request.sortDescriptors = [NSSortDescriptor(key: "entityId", ascending: true)]
        request.predicate = NSPredicate(format: "entityId == %@", localDate.onlyDate as CVarArg)
        do {
            let items = try viewContext.fetch(request) as! [MedEntry]
            if !items.isEmpty {
                let localEntry = items.first
                localEntry?.halfDose1 = medEntryDose1
                localEntry?.halfDose2 = medEntryDose2
                localEntry?.halfDose3 = medEntryDose3
                localEntry?.halfDose4 = medEntryDose4
                localEntry?.halfDose5 = medEntryDose5
                localEntry?.halfDose6 = medEntryDose6
                try? viewContext.save()
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewContext: PersistenceController.preview.container.viewContext)
    }
}
