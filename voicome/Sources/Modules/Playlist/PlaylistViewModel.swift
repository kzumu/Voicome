//
//  PlaylistViewModel.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PlaylistViewModel {

    enum Action {
        case download
    }

    enum State {
        case error(error: Error)
    }

    private let voiceDatas: BehaviorRelay<[VoicyResponse.VoiceData]>
    private let action: PublishSubject<Action>
    private let state: PublishSubject<State>
    private let disposeBag = DisposeBag()

    init(program: VoicyResponse.PlaylistData) {
        let datas = program.voiceDatas.enumerated().map {
            return VoicyResponse.VoiceData(articleTitle: $0.1.articleTitle,
                                           mediaName: $0.1.mediaName,
                                           voiceFile: $0.1.voiceFile,
                                           voiceIndex: $0.0 + 1,
                                           speakerName: program.speakerName,
                                           playlistName: program.playlistName)
        }
        self.voiceDatas = BehaviorRelay(value: datas)
        self.action = PublishSubject()
        self.state = PublishSubject()
        
        self.action
            .map(translate)
            .subscribe(onNext: {
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        let viewDidLoad: Driver<Void>
        let downloadButtonTapped: Driver<Void>
    }

    struct Output {
        let voiceDatas: BehaviorRelay<[VoicyResponse.VoiceData]>
        let state: PublishSubject<State>
    }

    func translate(_ input: Input) -> Output {
        input.downloadButtonTapped
            .drive(onNext: { [weak self] in
                self?.action.onNext(.download)
            }).disposed(by: disposeBag)

        return Output(voiceDatas: voiceDatas, state: state)
    }

    func translate(_ action: Action) {
        switch action {
        case .download:
            for v in voiceDatas.value {
                VoiProvider.rx.requestWithProgress(.voiceData(voice: v), callbackQueue: nil)
                    .subscribe(onNext: { (r) in
                        print(r.progress)
                    }, onError: { (e) in
                        print(e.localizedDescription)
                    }, onCompleted: {
                        print("download completed")
                    }, onDisposed: {
                    }).disposed(by: disposeBag)
            }
        }
    }
}
