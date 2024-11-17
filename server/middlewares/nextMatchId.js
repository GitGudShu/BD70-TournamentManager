/**
 * Function to compute the next match ID in an elimination tournament.
 * @param {number} totalParticipants - The total number of participants (2^n).
 * @param {number} match_id - The current match ID for which we want the next match.
 * @param {number} startingMatchId - The starting match ID in this tournament.
 * @returns {number|null} The next match ID in the next round, or null if it's the final round.
 */
export function getNextMatchId(totalParticipants, match_id, startingMatchId) {
    const totalRounds = Math.log2(totalParticipants);
    let currentRound = 1;
    let matchesInRound = totalParticipants / 2;
    let roundStartId = startingMatchId;
    let matchIndex = match_id - roundStartId;

    while (match_id >= roundStartId + matchesInRound) {
        roundStartId += matchesInRound; // Move to next round start ID
        matchesInRound /= 2; // Halve matches as we progress rounds
        currentRound++;
        matchIndex = match_id - roundStartId;
    }

    if (currentRound < totalRounds) {
        const nextMatchIndex = Math.floor(matchIndex / 2); // Integer division
        const nextRoundStartId = roundStartId + matchesInRound;
        return nextRoundStartId + nextMatchIndex;
    } else {
        return null; // Last round doesn't have a next match
    }
}

function testGetNextMatchIdWithOffset() {
    const totalParticipants = 16; // Example with 4 participants (2 rounds)
    const startingMatchId = 4; // Match IDs start from 4

    // Test different match IDs and log their next match IDs
    const maxMatchId = startingMatchId + totalParticipants - 2; // Match IDs range from 4 to 6
    for (let match_id = startingMatchId; match_id <= maxMatchId; match_id++) {
        const nextMatchId = getNextMatchId(totalParticipants, match_id, startingMatchId);
        console.log(`Match ID ${match_id} advances to next match ID: ${nextMatchId}`);
    }
}

// Run test
// testGetNextMatchIdWithOffset();
