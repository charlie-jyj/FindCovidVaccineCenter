# 코로나 19 예방 접종 센터 조회 

## 구현

### 1) 사용 기능

- Combine
- SwfitUI

### 2) 기본 개념

#### (1) Combine Framework

> Customize handling of asynchronous events by combining event-processing operators

Combine declares
publishers to expose values that can change over time, and
subscribers to receive those values from the publishers.

By adopting Combine, you'll make you code easier to read and maintain,
by centralizing your event-processing code and eliminating troublesome techniques like nested closures and convention-based callbacks.

##### ⏰ 비동기적인 인터페이스

- IBTarget/ IBAction
- Notification Center
- URLSession
- KVO
- Ad-hoc callbacks

closure, completion block을 받는 api
특정 closure에 전달되는 값을 다른 block으로 넘겨서 handling => 사용성 좋지 않음
위의 api들을 관통하는 개념 : A unified declarative API for processing values over time
시간에 따라 발생하는 값 처리, 비동기 적으로 발생하는 action, notification, url request/response, call back 등

##### 🍔 핵심 요소

1. Publishers
2. Subscribers
3. Operators

RX Swift 와 비교하기

|    RX Swift     |     Combine    |
| --------------- | -------------- |
| Observables     | Publishers     |
| Observers       | Subscribers    |
| Operators       | Operators      |
| Subject         | Subject        |
| Disposable      | Cancellable    |
| SubscribeOn(_:) | Subscribe(on:) |

1. publisher vs Observable

```swift
// stream 생성

public protocol Publisher {}
struct AnyPublisher: Puclisher {}  // value type
associatedtype Output
associatedtype Failure: Error 

AnyPublisher<String, Error>
AnyPublisher<String, Never>  // Error 가 발생할 수 없는 상황



class Observable: ObservableType {}  // reference type
class Observable<Element>  
// 따로 error 처리는 없지만 swift 5.0+ result type 을 주입하면 비슷하게 구현할 수 있다.
Observable<Result<String, Error>>
Observable<String>

```

2-1. Operators, RxSwift Only

- amb
- asObserver 
- concatMap
- create
- delaySubscription
- dematerialize
- enumerated
- flatMapFirst
- from
- groupBy
- ifEmpty(switchTo:)
- interrval
- materialize
- range
- repeatElement
- retryWhen
- sample
- withLatestFrom

2-2. Operators, Combine Only

- tryMap
- tryScan
- tryFilter
- tryCompactMap
- tryRemoveDuplicates(by:)
- tryReduce
- tryMax(by:)
- tryMin(by:)
- tryContains(where:)
- tryAllSatisfy
- tryDrop(while:)
- tryPrefix(while:)
- tryFirst(where:)
- tryLast(where:)
- tryCatch
*try operator는 error handling 을 도와준다*

- Merge, Merge3 ... Merge8, MergeMany
- CombineLatest, CombineLatest3, CombineLatest4
- Zip, Zip3, Zip4

3. Subject (Publishers 이면서 Subscriber)

3-1. Combine

- PassthroughSubject
- X
- CurrentValueSubject

```swift
class passthroughSubject<Output, Failure> {
    public init()
}

class CurrentValueSubject<Output, Failure> {
    public init(_ value: Output)
}

```

3-2. RX

- PublishSubject
- ReplaySubject
- BehaviorSubject

```swift
class PublishSubject<Element> {
    override init() 
}

class BehaviorSubject<Element> {
    init(value: Element)
}
```

4. Cancellable vs Disposable

> Observable 구독을 끊어주지 않으면 영원히 sequence가 살아있어 메모리 누수를 유발, deinit 시점에 sequence를 끊어준다. (autocancel)

하지만, Cancellable에는 DisposeBag 개념이 존재하지 않는다.

```swift
let cancellables = Set<Cancellable> ()
Just(1)
    .sink {
        print($0)
    }
    .store(in: &cancellables)


// 비교
let disposeBag = DisposeBag()
Observable.just(1)
    .subscibe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
```

> store: stores this type-erasing cancellable instance in the specified set.


5. Thread Handling

```swift
Just(1)  // sequence 생성
    .subscribe(on: DispatchQueue.main) // combine은 upstream에 대해서만 작동한다 (위, 아래 상관없는 RX와 달리)
    .map {
        _ in
        implrements()
    }
    .sink {...}
```

> sink: attaches a subscriber with closure-based behavior to publisher that never fails. Available when Failure is Never. use to observe values received by the publisher and process them using a closure you specify.

```swift
func sink(receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void), receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable

let myRange = (0...3)
cancellable = myRange.publisher
    .sink(receiveCompletion: { print ("completion: \($0)") },
          receiveValue: { print ("value: \($0)") })

// Prints:
//  value: 0
//  value: 1
//  value: 2
//  value: 3
//  completion: finished
```

return a cancellable instance, which you use when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.

- receiveComplete: the closure to execute on completion
- receiveValue: the closure to execute on receipt of a value


#### 2) SwiftUI + Combine

```swift
class SelectRegionViewModel: ObservableObject {}
```

- ObservableObject
A type of object with a publisher that emits before the object has changed.

By default an ObservableObject synthesizes an objectWillChange publisher that emits the changed value before any of its @Published properties changes.


#### 3) SwiftUI

##### NavigationView + NavigationLink

<https://seons-dev.tistory.com/21>

```swift
struct NavigationLink<Label, Destination> where Label : View, Destination : View

NavigationLink(destination: FolderList(id: workFolder.id)) {
    Label("Work Folder", systemImage: "folder")
}
```

Users click or tap a navigation link to present a view indside a NavigationView. You control the visual appearance of th elink by providing view content in the link's trailing closure.
<https://developer.apple.com/documentation/swiftui/navigationlink>

##### MapView

> A view that displays an embedded map interface, a map view displays a region. use this native SwiftUI view to optionally configure user-allowed interactions, display the user's location, and track a location

<https://developer.apple.com/documentation/mapkit/map>

```swift
import MapKit

// pin
struct AnnotationItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    var coordination: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    @State private var annotationItems = [AnnotationItem]()
        
    var body: some View {
        Map(
            coordinateRegion: $region,
            annotationItems: [AnnotationItem(coordinate: coordination)],
            annotationContent: {
                MapMarker(coordinate: $0.coordinate) // annotationItems를 하나 씩 받는
            })
            .onAppear {
                setRegion(coordination)
                setAnnotationItems(coordination)
            }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
    
    private func setAnnotationItems(_ coordinate: CLLocationCoordinate2D) {
        annotationItems = [AnnotationItem(coordinate: coordinate)]
    }
}

```

- coordinateRegion
  - MKDoordinateRegion
- annotationItems
- annotationContent
  - MapMarker
- onAppear

`annotation views`

- MapPin
- MapMarker
- MapAnnotation

### 3) 새롭게 알게 된 것

#### 🥩 request header 추가하기  

```swift
var request = URLRequest(url: url)
request.setValue("value", forHTTPHeaderField: "Authorization")
```

#### 🌽 Dictionary(grouping: by:)

> creates a new dictionary whose keys are the groupings returned by the given closure and whose values are arrays of the elements that returned each key.

```swift
init<S>(grouping values: S, by keyForValue: (S.Element) throws -> Key) rethrows where Value == [S.Element], S : Sequence

let students = ["Kofi", "Abena", "Efua", "Kweku", "Akosua"]
let studentsByLetter = Dictionary(grouping: students, by: { $0.first! })
// ["E": ["Efua"], "K": ["Kofi", "Kweku"], "A": ["Abena", "Akosua"]]
```

개인적으로, 매우 신기하다고 생각

#### 🥑 @observedObject vs @EnvironmentObject

you've seen how `@State` declares simple properties for a type that automatically cause a refresh of the view when it changes, and how `@ObservedObject` declares a property for an external type that may or may not cause a refresh of the view when it changes. Both of these two must be set by your view, but `@ObservedObject` might be shared with other views.

<https://www.hackingwithswift.com/quick-start/swiftui/whats-the-difference-between-observedobject-state-and-environmentobject>

#### 📞 url로 전화걸기

시뮬레이터에서는 확인할 수 없다.

```swift
if let url = URL(string: "tel:" + phoneNumber) {
    Link(center.phoneNumber, destination: url)
}
```
