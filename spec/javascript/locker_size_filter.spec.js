import LockerSizeFilter from "#components/locker_size_filter.js";

describe("LockerSizeFilter", () => {
  it("changes the locker options to only 6' for A floor", async () => {
    document.body.innerHTML =
      '<div id="locker-form-header"><a>Firestone Library</a></div><select id="locker_application_preferred_size"><option value="4">4-foot</option><option value="6">6-foot</option></select><select id="locker_application_preferred_general_area"><option value="A floor">A floor</option><option value="B floor">B floor</option></select>';
    new LockerSizeFilter();
    let select = await document.getElementById(
      "locker_application_preferred_general_area"
    );
    select.value = "A floor";
    // Fire the change event
    select.dispatchEvent(new Event("change"));

    expect(
      document.getElementById("locker_application_preferred_general_area").value
    ).toBe("A floor");
    expect(
      document
        .getElementById("locker_application_preferred_size")
        .getElementsByTagName("option").length
    ).toBe(1);

    // Changes back when another option is selected
    select.value = "B floor";
    select.dispatchEvent(new Event("change"));

    expect(
      document.getElementById("locker_application_preferred_general_area").value
    ).toBe("B floor");
    expect(
      document
        .getElementById("locker_application_preferred_size")
        .getElementsByTagName("option").length
    ).toBe(2);
  });
});
