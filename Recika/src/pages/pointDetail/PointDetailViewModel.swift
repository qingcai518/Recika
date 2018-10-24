//
//  PointDetailViewModel.swift
//  Recika
//
//  Created by liqc on 2018/10/24.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

class PointDetailViewModel {
    func doTransfer(completion: (String?) -> Void) {
        getChainId { chainId in
            guard let chainId = chainId else {
                return completion("fail to get chain id.")
            }
            
            guard let chainId = chainId else {
                return completion("fail top get chain id.")
            }
            
            guard let chainInfo = chainInfo else {
                return completion("fail to get chain Info.")
            }
            
            guard let chainInfo = chainInfo else {
                return completion("fail to get chain Info.")
            }
            
            guard let chainId = chainId else {
                return completion("fail to get chain id.")
            }
            
            guard let chainInfo = chainInfo else {
                return completion("fail to get chain info.")
            }
            
            guard let chainId = chainId else {
                return completion("fail to get chain id.")
            }
            
            guard let chainId = chainId else {
                return completion("failit to get chainId.")
            }
            
            
        }
    }
    
    func doTransfer(completion: (String?) -> Void) {
        getChainId { chainId in
            guard let chainId = chainId else {
                return
            }
        }
    }
}
