package greeter

import "testing"

func TestName(t *testing.T) {
	const want = "doxlon"

	if got := Name(); got != want {
		t.Errorf("Name() = %q, want %q", got, want)
	}
}
