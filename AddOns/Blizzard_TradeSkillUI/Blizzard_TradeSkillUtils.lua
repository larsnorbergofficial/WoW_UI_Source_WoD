function TradeSkillFrame_GenerateRankLinks(recipeInfo, optionalLinksSetToFillOut)
	if optionalLinksSetToFillOut then
		optionalLinksSetToFillOut[recipeInfo.recipeID] = true;
	end

	do -- Start by going backwards from this node until we find the first in the line
		local currentRecipeInfo = recipeInfo;
		local previousRecipeID = recipeInfo.previousRecipeID;
		
		while previousRecipeID do
			if optionalLinksSetToFillOut then
				optionalLinksSetToFillOut[previousRecipeID] = true;
			end

			local previousRecipeInfo = C_TradeSkillUI.GetRecipeInfo(previousRecipeID);
			currentRecipeInfo.previousRecipeInfo = previousRecipeInfo;
			previousRecipeInfo.nextRecipeInfo = currentRecipeInfo;
			currentRecipeInfo = previousRecipeInfo;
			previousRecipeID = currentRecipeInfo.previousRecipeID;
		end
	end

	do -- Now move forward from this node linking them until the end
		local currentRecipeInfo = recipeInfo;
		local nextRecipeID = recipeInfo.nextRecipeID;
		while nextRecipeID do
			if optionalLinksSetToFillOut then
				optionalLinksSetToFillOut[nextRecipeID] = true;
			end

			local nextRecipeInfo = C_TradeSkillUI.GetRecipeInfo(nextRecipeID);
			nextRecipeInfo.previousRecipeInfo = currentRecipeInfo;
			currentRecipeInfo.nextRecipeInfo = nextRecipeInfo;

			currentRecipeInfo = nextRecipeInfo;
			nextRecipeID = currentRecipeInfo.nextRecipeID;
		end
	end
end

-- Must have the links generated first via TradeSkillFrame_GenerateRankLinks
function TradeSkillFrame_CalculateRankInfoFromRankLinks(recipeInfo)
	local totalRanks = 0;
	local currentRank = 0;

	if recipeInfo then
		while recipeInfo.previousRecipeInfo do
			recipeInfo = recipeInfo.previousRecipeInfo;
		end

		while recipeInfo do
			totalRanks = totalRanks + 1;
			if recipeInfo.learned then
				currentRank = currentRank + 1;
			end
			recipeInfo = recipeInfo.nextRecipeInfo;
		end
	end

	return totalRanks, currentRank;
end