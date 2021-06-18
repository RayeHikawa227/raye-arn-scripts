CARD_OJAMAJO_CARNIVAL = 900146005

--shorting the effect of "During the Main Phase, you can:
--Immediately after this effect resolves,
--Normal Summon 1 "Magical of Smiles" monster from your hand."
--and also it supports to "ojamajo carnival" effect
--following of the parameters
--c: card
--id: the card id
--str: from cdb which is calling for Duel.Hint
function Auxiliary.CreateSummonEffect(c,id,str)
	local eff=Effect.CreateEffect(c)
	if id then
		eff:SetDescription(aux.Stringid(id,str))
	end
	eff:SetCategory(CATEGORY_SUMMON)
	eff:SetType(EFFECT_TYPE_IGNITION)
	eff:SetRange(LOCATION_MZONE)
	eff:SetCondition(Auxiliary.SummonCondition)
	eff:SetTarget(Auxiliary.SummonTarget)
	eff:SetOperation(Auxiliary.SummonOperation)
	c:RegisterEffect(eff)
	local affected=eff:Clone() 
	affected:SetType(EFFECT_TYPE_QUICK_O)
	affected:SetCode(EVENT_FREE_CHAIN)
	affected:SetCondition(Auxiliary.AffectedCondition)
	c:RegisterEffect(affected)
	return affected
end
function Auxiliary.SummonCondition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,CARD_OJAMAJO_CARNIVAL)
end
function Auxiliary.SummonFilter(c)
	return c:IsSetCard(0x700) and c:IsSummonable(true,nil)
end
function Auxiliary.SummonTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Auxiliary.SummonFilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function Auxiliary.SummonOperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,Auxiliary.SummonFilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function Auxiliary.AffectedCondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,CARD_OJAMAJO_CARNIVAL)
end

--shorting the effect of "then immediately after this effect resolves,
--you can Normal Summon 1 monster."
--following of the parameters
--e: effect
--tp: trigger player
--string: for "Duel.SelectYesNo"
--hint: for "Duel.Hint"
function Auxiliary.SummonFilter2(c)
	return c:IsSummonable(true,nil)
end
function Auxiliary.SummonBreakEffect(e,tp,string,hint)
	if Duel.IsExistingMatchingCard(Auxiliary.SummonFilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,string) then
		Duel.BreakEffect()
		Duel.Hint(HINT_OPSELECTED,1-tp,hint)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,Auxiliary.SummonFilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
