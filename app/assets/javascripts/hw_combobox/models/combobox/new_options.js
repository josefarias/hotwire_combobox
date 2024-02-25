import Combobox from "hw_combobox/models/combobox/base"

Combobox.NewOptions = Base => class extends Base {
  _shouldTreatAsNewOptionForFiltering(queryIsForwardLooking) {
    if (queryIsForwardLooking) {
      return this._isNewOptionWithNoPotentialMatches
    } else {
      return this._isNewOptionWithPotentialMatches
    }
  }

  // If the user is going to keep refining the query, we can't be sure whether
  // the option will end up being new or not unless there are no potential matches.
  // +_isNewOptionWithNoPotentialMatches+ allows us to make our best guess
  // while the state of the combobox is still in flux.
  //
  // It's okay for the combobox to say it's not new even if it will be eventually,
  // as only the final state matters for submission purposes. This method exists
  // as a best effort to keep the state accurate as often as we can.
  //
  // Note that the first visible option is automatically selected as you type.
  // So if there's a partial match, it's not a new option at this point.
  //
  // The final state is locked-in upon closing the combobox via `_isNewOptionWithPotentialMatches`.
  get _isNewOptionWithNoPotentialMatches() {
    return this._isNewOptionWithPotentialMatches && !this._isPartialAutocompleteMatch
  }

  // If the query is finalized, we don't care that there are potential matches
  // because new options can be substrings of existing options.
  //
  // We can't use `_isNewOptionWithNoPotentialMatches` because that would
  // rule out new options that are partial matches.
  get _isNewOptionWithPotentialMatches() {
    return this._isQueried && this._allowNew && !this._isExactAutocompleteMatch
  }
}
