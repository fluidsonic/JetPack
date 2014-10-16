import Foundation


func onMainThread(block: Block) {
	dispatch_async(dispatch_get_main_queue(), block)
}


func onMainThread(afterDelay delay: NSTimeInterval, block: Block) {
	let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
	dispatch_after(time, dispatch_get_main_queue(), block)
}
