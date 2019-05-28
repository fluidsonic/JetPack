import Foundation


internal extension Locale {

	static let pluralCategoryResolversByLocaleIdentifier: [String : PluralCategoryResolver] = [
		"af": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"ak": resolve_pa$nso$ti$mg$wa$bh$guw$ak$ln,
		"am": resolve_gu$bn$fa$kn$as$hi$mr$zu$am,
		"ar": resolve_ar,
		"as": resolve_gu$bn$fa$kn$as$hi$mr$zu$am,
		"asa": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"ast": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"az": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"be": resolve_be,
		"bem": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"bez": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"bg": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"bh": resolve_pa$nso$ti$mg$wa$bh$guw$ak$ln,
		"bm": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"bn": resolve_gu$bn$fa$kn$as$hi$mr$zu$am,
		"bo": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"br": resolve_br,
		"brx": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"bs": resolve_bs$hr$sh$sr,
		"ca": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"ce": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"cgg": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"chr": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"ckb": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"cs": resolve_sk$cs,
		"cy": resolve_cy,
		"da": resolve_da,
		"de": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"dsb": resolve_hsb$dsb,
		"dv": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"dz": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"ee": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"el": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"en": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"eo": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"es": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"et": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"eu": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"fa": resolve_gu$bn$fa$kn$as$hi$mr$zu$am,
		"ff": resolve_kab$ff$fr$hy,
		"fi": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"fil": resolve_tl$fil,
		"fo": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"fr": resolve_kab$ff$fr$hy,
		"fur": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"fy": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"ga": resolve_ga,
		"gd": resolve_gd,
		"gl": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"gsw": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"gu": resolve_gu$bn$fa$kn$as$hi$mr$zu$am,
		"guw": resolve_pa$nso$ti$mg$wa$bh$guw$ak$ln,
		"gv": resolve_gv,
		"ha": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"haw": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"he": resolve_he$iw,
		"hi": resolve_gu$bn$fa$kn$as$hi$mr$zu$am,
		"hr": resolve_bs$hr$sh$sr,
		"hsb": resolve_hsb$dsb,
		"hu": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"hy": resolve_kab$ff$fr$hy,
		"id": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"ig": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"ii": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"in": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"is": resolve_is,
		"it": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"iu": resolve_sma$smi$sms$smn$iu$naq$smj$kw$se,
		"iw": resolve_he$iw,
		"ja": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"jbo": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"jgo": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"ji": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"jmc": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"jv": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"jw": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"ka": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"kab": resolve_kab$ff$fr$hy,
		"kaj": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"kcg": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"kde": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"kea": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"kk": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"kkj": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"kl": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"km": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"kn": resolve_gu$bn$fa$kn$as$hi$mr$zu$am,
		"ko": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"ks": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"ksb": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"ksh": resolve_ksh,
		"ku": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"kw": resolve_sma$smi$sms$smn$iu$naq$smj$kw$se,
		"ky": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"lag": resolve_lag,
		"lb": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"lg": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"lkt": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"ln": resolve_pa$nso$ti$mg$wa$bh$guw$ak$ln,
		"lo": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"lt": resolve_lt,
		"lv": resolve_prg$lv,
		"mas": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"mg": resolve_pa$nso$ti$mg$wa$bh$guw$ak$ln,
		"mgo": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"mk": resolve_mk,
		"ml": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"mn": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"mo": resolve_ro$mo,
		"mr": resolve_gu$bn$fa$kn$as$hi$mr$zu$am,
		"ms": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"mt": resolve_mt,
		"my": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"nah": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"naq": resolve_sma$smi$sms$smn$iu$naq$smj$kw$se,
		"nb": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"nd": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"ne": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"nl": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"nn": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"nnh": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"no": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"nqo": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"nr": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"nso": resolve_pa$nso$ti$mg$wa$bh$guw$ak$ln,
		"ny": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"nyn": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"om": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"or": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"os": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"pa": resolve_pa$nso$ti$mg$wa$bh$guw$ak$ln,
		"pap": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"pl": resolve_pl,
		"prg": resolve_prg$lv,
		"ps": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"pt": resolve_pt,
		"pt_PT": resolve_pt_PT,
		"rm": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"ro": resolve_ro$mo,
		"rof": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"root": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"ru": resolve_uk$ru,
		"rwk": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"sah": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"saq": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"sdh": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"se": resolve_sma$smi$sms$smn$iu$naq$smj$kw$se,
		"seh": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"ses": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"sg": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"sh": resolve_bs$hr$sh$sr,
		"shi": resolve_shi,
		"si": resolve_si,
		"sk": resolve_sk$cs,
		"sl": resolve_sl,
		"sma": resolve_sma$smi$sms$smn$iu$naq$smj$kw$se,
		"smi": resolve_sma$smi$sms$smn$iu$naq$smj$kw$se,
		"smj": resolve_sma$smi$sms$smn$iu$naq$smj$kw$se,
		"smn": resolve_sma$smi$sms$smn$iu$naq$smj$kw$se,
		"sms": resolve_sma$smi$sms$smn$iu$naq$smj$kw$se,
		"sn": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"so": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"sq": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"sr": resolve_bs$hr$sh$sr,
		"ss": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"ssy": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"st": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"sv": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"sw": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"syr": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"ta": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"te": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"teo": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"th": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"ti": resolve_pa$nso$ti$mg$wa$bh$guw$ak$ln,
		"tig": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"tk": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"tl": resolve_tl$fil,
		"tn": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"to": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"tr": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"ts": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"tzm": resolve_tzm,
		"ug": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"uk": resolve_uk$ru,
		"ur": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"uz": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"ve": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"vi": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"vo": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"vun": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"wa": resolve_pa$nso$ti$mg$wa$bh$guw$ak$ln,
		"wae": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"wo": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"xh": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"xog": resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr,
		"yi": resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw,
		"yo": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"zh": resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo,
		"zu": resolve_gu$bn$fa$kn$as$hi$mr$zu$am,
	]
}


private func resolve_kde$ig$my$ko$to$kea$id$ms$lkt$bm$th$bo$sah$root$lo$jw$ses$vi$yo$jv$dz$km$in$ja$sg$ii$nqo$wo$zh$jbo(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	return .other
}


private func resolve_gu$bn$fa$kn$as$hi$mr$zu$am(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if i == 0 || n == 1 { return .one }
	return .other
}


private func resolve_kab$ff$fr$hy(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if (i == 0 || i == 1) { return .one }
	return .other
}


private func resolve_ast$fi$fy$gl$ji$ur$ca$en$de$it$et$nl$yi$sv$sw(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if i == 1 && v == 0 { return .one }
	return .other
}


private func resolve_si(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if (n == 0 || n == 1) || (i == 0 && f == 1) { return .one }
	return .other
}


private func resolve_pa$nso$ti$mg$wa$bh$guw$ak$ln(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if (0...1).contains(n) { return .one }
	return .other
}


private func resolve_tzm(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if (0...1).contains(n) || (11...99).contains(n) { return .one }
	return .other
}


private func resolve_pt(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if (0...2).contains(n) && n != 2 { return .one }
	return .other
}


private func resolve_no$cgg$uz$ce$lg$brx$fo$fur$tk$bez$jmc$ky$mas$or$nr$seh$mn$st$rwk$eu$syr$ckb$ta$teo$ug$vo$wae$xh$nn$el$ml$tig$ts$gsw$kl$so$bem$os$bg$nd$te$xog$ha$dv$kkj$rof$ps$ne$nb$ve$sq$rm$sdh$ss$af$hu$kcg$pap$lb$ku$mgo$asa$sn$vun$ka$eo$haw$jgo$ks$ee$es$ny$nyn$om$ssy$tn$kaj$tr$nah$az$ksb$kk$saq$nnh$chr(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if n == 1 { return .one }
	return .other
}


private func resolve_pt_PT(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if n == 1 && v == 0 { return .one }
	return .other
}


private func resolve_da(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if n == 1 || (t != 0 && (i == 0 || i == 1)) { return .one }
	return .other
}


private func resolve_is(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if (t == 0 && iMod % 10 == 1 && iMod % 100 != 11) || t != 0 { return .one }
	return .other
}


private func resolve_mk(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if (v == 0 && iMod % 10 == 1) || fMod % 10 == 1 { return .one }
	return .other
}


private func resolve_tl$fil(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if ((v == 0 && ((i == 1 || i == 2) || i == 3)) || (v == 0 && ((iMod % 10 != 4 || iMod % 10 != 6) || iMod % 10 != 9))) || (v != 0 && ((fMod % 10 != 4 || fMod % 10 != 6) || fMod % 10 != 9)) { return .one }
	return .other
}


private func resolve_prg$lv(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if (nMod % 10 == 0 || (11...19).contains(nMod % 100)) || (v == 2 && (11...19).contains(fMod % 100)) { return .zero }
	if ((nMod % 10 == 1 && nMod % 100 != 11) || (v == 2 && fMod % 10 == 1 && fMod % 100 != 11)) || (v != 2 && fMod % 10 == 1) { return .one }
	return .other
}


private func resolve_lag(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if n == 0 { return .zero }
	if (i == 0 || i == 1) && n != 0 { return .one }
	return .other
}


private func resolve_ksh(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if n == 0 { return .zero }
	if n == 1 { return .one }
	return .other
}


private func resolve_sma$smi$sms$smn$iu$naq$smj$kw$se(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if n == 1 { return .one }
	if n == 2 { return .two }
	return .other
}


private func resolve_shi(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if i == 0 || n == 1 { return .one }
	if (2...10).contains(n) { return .few }
	return .other
}


private func resolve_ro$mo(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if i == 1 && v == 0 { return .one }
	if (v != 0 || n == 0) || (n != 1 && (1...19).contains(nMod % 100)) { return .few }
	return .other
}


private func resolve_bs$hr$sh$sr(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if (v == 0 && iMod % 10 == 1 && iMod % 100 != 11) || (fMod % 10 == 1 && fMod % 100 != 11) { return .one }
	if (v == 0 && (2...4).contains(iMod % 10) && !(12...14).contains(iMod % 100)) || ((2...4).contains(fMod % 10) && !(12...14).contains(fMod % 100)) { return .few }
	return .other
}


private func resolve_gd(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if (n == 1 || n == 11) { return .one }
	if (n == 2 || n == 12) { return .two }
	if ((3...10).contains(n) || (13...19).contains(n)) { return .few }
	return .other
}


private func resolve_sl(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if v == 0 && iMod % 100 == 1 { return .one }
	if v == 0 && iMod % 100 == 2 { return .two }
	if (v == 0 && (3...4).contains(iMod % 100)) || v != 0 { return .few }
	return .other
}


private func resolve_hsb$dsb(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if (v == 0 && iMod % 100 == 1) || fMod % 100 == 1 { return .one }
	if (v == 0 && iMod % 100 == 2) || fMod % 100 == 2 { return .two }
	if (v == 0 && (3...4).contains(iMod % 100)) || (3...4).contains(fMod % 100) { return .few }
	return .other
}


private func resolve_he$iw(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if i == 1 && v == 0 { return .one }
	if i == 2 && v == 0 { return .two }
	if v == 0 && !(0...10).contains(n) && nMod % 10 == 0 { return .many }
	return .other
}


private func resolve_sk$cs(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if i == 1 && v == 0 { return .one }
	if (2...4).contains(i) && v == 0 { return .few }
	if v != 0 { return .many }
	return .other
}


private func resolve_pl(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if i == 1 && v == 0 { return .one }
	if v == 0 && (2...4).contains(iMod % 10) && !(12...14).contains(iMod % 100) { return .few }
	if ((v == 0 && i != 1 && (0...1).contains(iMod % 10)) || (v == 0 && (5...9).contains(iMod % 10))) || (v == 0 && (12...14).contains(iMod % 100)) { return .many }
	return .other
}


private func resolve_be(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if nMod % 10 == 1 && nMod % 100 != 11 { return .one }
	if (2...4).contains(nMod % 10) && !(12...14).contains(nMod % 100) { return .few }
	if (nMod % 10 == 0 || (5...9).contains(nMod % 10)) || (11...14).contains(nMod % 100) { return .many }
	return .other
}


private func resolve_lt(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if nMod % 10 == 1 && !(11...19).contains(nMod % 100) { return .one }
	if (2...9).contains(nMod % 10) && !(11...19).contains(nMod % 100) { return .few }
	if f != 0 { return .many }
	return .other
}


private func resolve_mt(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if n == 1 { return .one }
	if n == 0 || (2...10).contains(nMod % 100) { return .few }
	if (11...19).contains(nMod % 100) { return .many }
	return .other
}


private func resolve_uk$ru(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if v == 0 && iMod % 10 == 1 && iMod % 100 != 11 { return .one }
	if v == 0 && (2...4).contains(iMod % 10) && !(12...14).contains(iMod % 100) { return .few }
	if ((v == 0 && iMod % 10 == 0) || (v == 0 && (5...9).contains(iMod % 10))) || (v == 0 && (11...14).contains(iMod % 100)) { return .many }
	return .other
}


private func resolve_br(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if nMod % 10 == 1 && ((nMod % 100 != 11 || nMod % 100 != 71) || nMod % 100 != 91) { return .one }
	if nMod % 10 == 2 && ((nMod % 100 != 12 || nMod % 100 != 72) || nMod % 100 != 92) { return .two }
	if ((3...4).contains(nMod % 10) || nMod % 10 == 9) && ((!(10...19).contains(nMod % 100) || !(70...79).contains(nMod % 100)) || !(90...99).contains(nMod % 100)) { return .few }
	if n != 0 && nMod % 1000000 == 0 { return .many }
	return .other
}


private func resolve_ga(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if n == 1 { return .one }
	if n == 2 { return .two }
	if (3...6).contains(n) { return .few }
	if (7...10).contains(n) { return .many }
	return .other
}


private func resolve_gv(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if v == 0 && iMod % 10 == 1 { return .one }
	if v == 0 && iMod % 10 == 2 { return .two }
	if v == 0 && ((((iMod % 100 == 0 || iMod % 100 == 20) || iMod % 100 == 40) || iMod % 100 == 60) || iMod % 100 == 80) { return .few }
	if v != 0 { return .many }
	return .other
}


private func resolve_ar(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if n == 0 { return .zero }
	if n == 1 { return .one }
	if n == 2 { return .two }
	if (3...10).contains(nMod % 100) { return .few }
	if (11...99).contains(nMod % 100) { return .many }
	return .other
}


private func resolve_cy(f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> Locale.PluralCategory {
	if n == 0 { return .zero }
	if n == 1 { return .one }
	if n == 2 { return .two }
	if n == 3 { return .few }
	if n == 6 { return .many }
	return .other
}
