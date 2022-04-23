import SpriteKit

extension SKLabelNode{
    func startTyping(_ duration:TimeInterval, completion:(()->Void)?){
        guard let text = self.text else{return}

        self.text = ""
        var index = 0
        var block:(() -> Void)!
        block = {
            index += 1
            if index > text.count{
                completion?()
                return
            }else{
                let action = SKAction.sequence([SKAction.wait(forDuration: duration), SKAction.run{self.text = String(text.prefix(index))}])
                self.run(action, completion: block)
            }
        }
        block()
    }
}
