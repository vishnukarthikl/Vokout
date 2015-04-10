describe('Account setup', function () {

    it('should sign up', function () {
        browser.get('http://localhost:3000');

        element(by.id('signup')).click();
        name = Math.random().toString(36).substring(7);
        element(by.id('owner_name')).sendKeys(name);
        element(by.id('owner_email')).sendKeys(name + '@vorkout.com');
        element(by.id('owner_password')).sendKeys('123456');
        element(by.id('owner_password_confirmation')).sendKeys('123456');
        element(by.id('signup-button')).click();
        browser.driver.sleep(5);
    });

    it('should setup facility', function () {
        saveButton = element(by.id('facilitySave'));
        expect(saveButton.isEnabled()).toBe(false);

        element(by.model('newFacility.name')).sendKeys('ABC Fitness');
        element(by.model('newFacility.address')).sendKeys('Peelamedu');
        element(by.model('newFacility.phone')).sendKeys('9876543210');

        expect(saveButton.isEnabled()).toBe(true);
        saveButton.click()
    });

    it('should setup memberships', function () {
        saveButton = element(by.id('membershipSave'));
        memberSetupButton = element(by.id('memberSetupButton'));
        expect(saveButton.isEnabled()).toBe(false);
        expect(memberSetupButton.isDisplayed()).toBe(false);

        var membershipName = 'monthly';
        element(by.model('newMembership.name')).sendKeys(membershipName);
        element(by.model('newMembership.duration')).sendKeys('1');
        element(by.model('newMembership.cost')).sendKeys('1000');

        expect(saveButton.isEnabled()).toBe(true);
        saveButton.click();

        var rows = element.all(by.repeater('membership in facility.memberships'));
        expect(rows.count()).toBe(1);
        expect(memberSetupButton.isDisplayed()).toBe(true);

    });

    it('should add mutiple memberships', function () {
        saveButton = element(by.id('membershipSave'));
        memberSetupButton = element(by.id('memberSetupButton'));
        expect(saveButton.isEnabled()).toBe(false);
        expect(memberSetupButton.isDisplayed()).toBe(true);

        var membershipName = 'yearly';
        element(by.model('newMembership.name')).sendKeys(membershipName);
        element(by.model('newMembership.duration')).sendKeys('1');
        element(by.model('newMembership.duration_type')).$('[value="2"]').click();
        element(by.model('newMembership.cost')).sendKeys('10000');

        expect(saveButton.isEnabled()).toBe(true);
        saveButton.click();

        var rows = element.all(by.repeater('membership in facility.memberships'));
        expect(rows.count()).toBe(2);
        expect(memberSetupButton.isEnabled()).toBe(true);
    });

    it('should save membership when step 3 button is pressed', function () {
        saveButton = element(by.id('membershipSave'));
        memberSetupButton = element(by.id('memberSetupButton'));
        setupMembershipBack = element(by.id('setupMembershipBack'));
        expect(saveButton.isEnabled()).toBe(false);

        var membershipName = '15 days';
        element(by.model('newMembership.name')).sendKeys(membershipName);
        element(by.model('newMembership.duration')).sendKeys('15');
        element(by.model('newMembership.duration_type')).$('[value="0"]').click();
        element(by.model('newMembership.cost')).sendKeys('500');

        expect(saveButton.isEnabled()).toBe(true);
        memberSetupButton.click();
        setupMembershipBack.click();

        var rows = element.all(by.repeater('membership in facility.memberships'));
        expect(rows.count()).toBe(3);
        memberSetupButton.click();
    });

    it('should add members', function () {
        savememberButton = element(by.id('savememberButton'));
        expect(savememberButton.isEnabled()).toBe(false);

        element(by.model('newMember.name')).sendKeys("karthik");
        element(by.model('newMember.is_male')).$('[value="true"]').click();
        element(by.model('newMember.subscription.membership_id')).$('[label="monthly"]').click();
        element(by.model('newMember.phone_number')).sendKeys("9982827782");

        savememberButton.click();

        element.all(by.repeater('member in facility.members')).then(function (elements) {
            count = elements.length;
            expect(count).toEqual(1);
        });

    });
});