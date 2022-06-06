import SwiftUI
import Foundation
import UIKit

struct CalendarView: View {
    
    @Binding var pillList : [pillModel]
    
    @State var selectTiemManager = SelectTimeManager.selectTimeManager
    @State var takeCheckManager = TakeCheckManager.takeCheckManager
    
    @State var EatedDay : [Int] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    
    let monthToDisplay: Date

//    init(pillList:[pillModel], monthToDisplay: Date) {
//        self.pillList = pillList
//        self.monthToDisplay = monthToDisplay
//    }
        
    //현재일자
    var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "dd"//2022-05-17|11:52:46
        return formatter
    }()
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            // Week day labels
            ForEach(["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"], id: \.self) { weekdayName in
                Text(weekdayName)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red:188/255, green: 191/255, blue:240/255))
            }
            
            // Day number text
            Section {
                //해당하는 월의 날자 수만큼 반복
                ForEach(monthToDisplay.getDaysForMonth(), id: \.self) { date in
                    // 주어진 월에 대한 일만 표시 ex)5월이면 31까지 4월이면 30까지
                    if Calendar.current.isDate(date, equalTo: monthToDisplay, toGranularity: .month) {
                        
                        if self.EatedDay[date.getDayNumber()] == 0
                        {
                        }
                        // 선택된 일자가 현재 혹은 과거인 경우
                        else
                        {
                            if date.getDayNumber() <= monthToDisplay.getDayNumber()
                            {
                                if self.EatedDay[date.getDayNumber()] == 3
                                {
                                    Text("\(date.getDayNumber())")
                                        .padding(8)
                                        .foregroundColor(.white)
                                        .background(Color.green)
                                        .cornerRadius(8)
                                        .id(date)
                                }
                                
                                else if self.EatedDay[date.getDayNumber()] == 2
                                {
                                    Text("\(date.getDayNumber())")
                                        .padding(8)
                                        .foregroundColor(.white)
                                        .background(Color.orange)
                                        .cornerRadius(8)
                                        .id(date)
                                }
                                
                                else if self.EatedDay[date.getDayNumber()] == 1
                                {
                                    Text("\(date.getDayNumber())")
                                        .padding(8)
                                        .foregroundColor(.white)
                                        .background(Color.red)
                                        .cornerRadius(8)
                                        .id(date)
                                }
                            }
                            
                            else//선택된 일자가 현재 일자보다 미래인 경우
                            {
                                Text("\(date.getDayNumber())")
                                    .padding(8)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .id(date)
                            }
                        }
                    }
                    
                    //이번달의 일자가 아닌경우
                    else {
                        Text("\(date.getDayNumber())")
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(8)
                            .hidden()
                    }
                }//ForEach1
            }
        }.onAppear(perform: {
            //년 월 포멧으로 현재 년, 월을 스트링으로 저장
            let yyyy_MM_format = DateFormatter()
            yyyy_MM_format.dateFormat = "yyyy-MM"
            let now_yyyy_MM = yyyy_MM_format.string(from: Date())
            var iter = 0
            //일자 포맷
            let dd_format = DateFormatter()
            dd_format.dateFormat = "dd"
            
            //이 사용자가 가진 약의 모듈들에 대한 섭취 횟수를 모두 더 하여 하루에 먹어야 하는 약의 갯수를 출력
            var haveToEat = 0
            for pill in self.pillList{
                haveToEat = haveToEat + Int(pill.PillTime ?? "")! + 1
            }
            print("haveToEat"+String(haveToEat))
            
            self.takeCheckManager.run = true
            var eated = self.takeCheckManager.takeCheck(pillMaster: self.pillList.first?.PillMaster ?? "")
            var eatCnt = eated.count
            //섭취해야하는 횟수와 실제 섭취 횟수를 비교하여 배열에 결과값을 넣음
            for value in self.monthToDisplay.getDaysForMonth(){
                //일자 포멧으로 선택된 일자를 스트링으로 저장
                var select_ddInt = value.getDayNumber()
                var select_ddString : String
                
                if select_ddInt <= 9
                {
                    select_ddString = "0" + String(select_ddInt)
                }
                else
                {
                    select_ddString = String(select_ddInt)
                }
                
                if haveToEat != 0 && iter < eatCnt && now_yyyy_MM+"-"+select_ddString == eated[iter].startDate   //면서 startDate와 선택된 날짜와 같은경우
                {
                    //약을 모두 먹은경우
                    if Int(eated[iter].cnt ?? "")! == haveToEat
                    {
                        self.EatedDay[value.getDayNumber()] = 3
                    }
                    //약을 1개 이상 먹은경우
                    else if Int(eated[iter].cnt ?? "")! >= 1
                    {
                        self.EatedDay[value.getDayNumber()] = 2
                    }
                    //약을 하나도 먹지 않은 경우
                    else if Int(eated[iter].cnt ?? "")! == 0
                    {
                        self.EatedDay[value.getDayNumber()] = 1
                    }
                    iter = iter + 1
                }
            }
            print(EatedDay)
        })
    }
}


extension Date {
    
    func getDayNumber()->Int {
        return Calendar.current.component(.day, from: self) ?? 0
    }
    
    func getDaysForMonth() -> [Date] {
        guard
            let monthInterval = Calendar.current.dateInterval(of: .month, for: self),
            let monthFirstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else {
            return []
        }
        let resultDates = Calendar.current.generateDates(inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
                                                         matching: DateComponents(hour: 0, minute: 0, second: 0))
        return resultDates
    }
    
}

extension Calendar {
    
    func generateDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates = [interval.start]
        enumerateDates(startingAfter: interval.start,
                       matching: components,
                       matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        return dates
    }
}
