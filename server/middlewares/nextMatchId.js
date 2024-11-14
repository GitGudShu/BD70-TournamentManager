// tournament.js

/**
 * Function to compute the next match ID in an elimination tournament.
 * @param {number} totalParticipants - The total number of participants (2^n).
 * @param {number} match_id - The current match ID for which we want the next match.
 * @returns {number|null} The next match ID in the next round, or null if it's the final round.
 */
function getNextMatchId(totalParticipants, match_id) {
    // Calculate the total number of rounds (log base 2 of total participants)
    const totalRounds = Math.log2(totalParticipants);

    // Initialize variables to locate the match within rounds
    let currentRound = 1;
    let matchesInRound = totalParticipants / 2;
    let roundStartId = 1;
    let matchIndex = match_id - roundStartId;

    // Find the round where this match_id is located
    while (match_id >= roundStartId + matchesInRound) {
        roundStartId += matchesInRound;  // Move to next round start ID
        matchesInRound /= 2;             // Halve matches as we progress rounds
        currentRound++;
        matchIndex = match_id - roundStartId;
    }

    // Calculate the next match ID in the subsequent round
    if (currentRound < totalRounds) {
        const nextMatchIndex = Math.floor(matchIndex / 2); // Integer division
        const nextRoundStartId = roundStartId + matchesInRound;
        return nextRoundStartId + nextMatchIndex;
    } else {
        // Last round doesn't have a next match
        return null;
    }
}

// Test function
function testGetNextMatchId() {
    const totalParticipants = 32; // Example with 16 participants (4 rounds)

    // Test different match_ids and log their next match IDs
    for (let match_id = 1; match_id < totalParticipants; match_id++) {
        const nextMatchId = getNextMatchId(totalParticipants, match_id);
        console.log(`Match ID ${match_id} advances to next match ID: ${nextMatchId}`);
    }
}

// Run test
testGetNextMatchId();
